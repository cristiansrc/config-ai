---
name: rest-error-response-standards
description: Estandariza respuestas HTTP de error en APIs Spring Boot usando RestControllerAdvice. Usar cuando se diseñen o implementen respuestas diferentes a 200/201, manejo de excepciones, validaciones, errores de negocio, autenticación/autorización, OpenAPI o contratos REST.
---

# REST Error Response Standards

Esta skill define un contrato único para todas las respuestas fallidas de APIs REST Spring Boot.

## 1. Alcance
- Aplicar a toda respuesta HTTP diferente de éxito funcional: `400`, `401`, `403`, `404`, `409`, `422`, `429`, `500`, `503` y equivalentes.
- No envolver respuestas `200` ni `201` si el proyecto ya tiene contrato propio para éxitos.
- Centralizar los errores con `@RestControllerAdvice`; evitar `try/catch` repetido en controllers.
- El controller solo debe orquestar request/response; la traducción de excepciones a HTTP vive en el advice.
- Toda API Spring Boot debe tener un handler global que capture tanto excepciones esperadas como no esperadas.
- Cualquier excepción no controlada debe llegar al handler global y responder con la misma estructura estándar, normalmente `500 INTERNAL_ERROR`, sin stack trace ni mensaje interno.

## 2. Estructura Estándar

Usar una estructura estable y serializable:

```json
{
  "timestamp": "2026-05-09T18:30:00Z",
  "status": 400,
  "error": "BAD_REQUEST",
  "code": "VALIDATION_ERROR",
  "message": "The request contains invalid fields.",
  "path": "/api/users",
  "trace_id": "4f0f6d2c6b1d4c8a",
  "details": [
    {
      "field": "email",
      "code": "EMAIL_INVALID",
      "message": "must be a well-formed email address",
      "rejected_value": "bad-email"
    }
  ]
}
```

Campos:
- `timestamp`: instante UTC ISO-8601.
- `status`: HTTP status numérico.
- `error`: nombre estándar del status HTTP.
- `code`: código estable de negocio o técnico, apto para frontend/i18n.
- `message`: mensaje seguro para cliente; no exponer stack traces ni detalles internos.
- `path`: path solicitado.
- `trace_id`: correlación desde MDC, tracing o request header.
- `details`: lista opcional para errores de campo, reglas de negocio o violaciones específicas.

## 3. Códigos Recomendados

- `400 BAD_REQUEST`: request mal formado, tipos inválidos, JSON inválido.
- `401 UNAUTHORIZED`: token ausente, inválido o expirado.
- `403 FORBIDDEN`: usuario autenticado sin permiso.
- `404 NOT_FOUND`: recurso inexistente.
- `409 CONFLICT`: conflicto de estado, duplicados, concurrencia optimista.
- `422 UNPROCESSABLE_ENTITY`: regla de negocio inválida con request sintácticamente correcto.
- `429 TOO_MANY_REQUESTS`: límite de tasa.
- `500 INTERNAL_SERVER_ERROR`: error inesperado.
- `503 SERVICE_UNAVAILABLE`: dependencia temporalmente no disponible.

## 4. RestControllerAdvice

Implementar un único advice global por bounded context o aplicación:

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(MethodArgumentNotValidException.class)
  ResponseEntity<ApiErrorResponse> handleValidation(
      MethodArgumentNotValidException exception,
      HttpServletRequest request
  ) {
    var details = exception.getBindingResult().getFieldErrors().stream()
        .map(error -> ApiErrorDetail.field(
            error.getField(),
            "FIELD_INVALID",
            error.getDefaultMessage(),
            safeRejectedValue(error.getRejectedValue())
        ))
        .toList();

    return build(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR",
        "The request contains invalid fields.", request, details);
  }
}
```

Reglas:
- Usar `@RestControllerAdvice` o `@ControllerAdvice` + `@ResponseBody` como punto único de traducción HTTP.
- Los controllers no deben construir errores manualmente ni capturar excepciones para formatear respuestas, salvo casos muy locales y justificados.
- Manejar validaciones de `jakarta.validation`.
- Manejar JSON inválido (`HttpMessageNotReadableException`) como `400`.
- Manejar errores de dominio con excepciones propias y códigos estables.
- Manejar `AccessDeniedException` como `403`.
- Manejar errores no controlados con `500` y mensaje genérico.
- Loguear el error real en backend, pero responder datos seguros al cliente.
- Mantener un método `@ExceptionHandler(Exception.class)` como red de seguridad final.
- Mantener un método `@ExceptionHandler(RuntimeException.class)` solo si no oculta excepciones de dominio más específicas; handlers específicos deben declararse antes o resolverse por tipo.
- Si el proyecto usa Spring Security, integrar handlers equivalentes para `AuthenticationException`/entry point (`401`) y `AccessDeniedException` (`403`) para conservar la misma estructura.
- Si el proyecto usa WebFlux, aplicar el patrón equivalente con `@RestControllerAdvice` reactivo o `ErrorWebExceptionHandler`, manteniendo el mismo contrato.

## 4.1 Fallback obligatorio para excepciones no controladas

Todo servicio debe tener un fallback global para impedir respuestas inconsistentes o HTML/whitelabel error pages.

Ejemplo:

```java
@ExceptionHandler(Exception.class)
ResponseEntity<ApiErrorResponse> handleUnexpected(
    Exception exception,
    HttpServletRequest request
) {
  log.error("Unhandled exception. trace_id={}", traceId(), exception);

  return build(
      HttpStatus.INTERNAL_SERVER_ERROR,
      "INTERNAL_ERROR",
      "An unexpected error occurred.",
      request,
      List.of()
  );
}
```

Reglas del fallback:
- Debe ser el último handler lógico; no debe reemplazar handlers específicos.
- Debe registrar la excepción real con stack trace en logs internos.
- La respuesta al cliente debe ser segura y estable.
- No debe usar `exception.getMessage()` como `message` público.
- Debe incluir `timestamp`, `status`, `error`, `code`, `message`, `path`, `trace_id` y `details`.
- Debe evitar que Spring devuelva páginas HTML, Whitelabel Error Page o mapas ad hoc.

## 4.2 Errores desde capas de aplicación/servicio

Los servicios de aplicación y dominio no deben retornar `ResponseEntity` ni construir payloads HTTP. Deben:
- Retornar resultados de negocio exitosos, o
- Lanzar excepciones de dominio/aplicación con código estable, o
- Usar un tipo resultado interno que el controller/advice traduzca de forma centralizada.

Patrón recomendado:
- Dominio: excepciones puras sin dependencia de Spring cuando sea posible.
- Aplicación: excepciones con `code`, `status` o mapeo centralizado.
- Infraestructura HTTP: `GlobalExceptionHandler` convierte esas excepciones a `ApiErrorResponse`.

Esto evita que cada servicio/controller invente estructuras diferentes.

## 5. Excepciones de Dominio

Las excepciones de dominio deben tener código estable:

```java
public class BusinessException extends RuntimeException {
  private final String code;
  private final HttpStatus status;
}
```

Ejemplos:
- `USER_ALREADY_EXISTS` -> `409`
- `USER_NOT_FOUND` -> `404`
- `DOCUMENT_NUMBER_ALREADY_REGISTERED` -> `409`
- `INVALID_USER_STATUS_TRANSITION` -> `422`

## 6. OpenAPI

Documentar cada respuesta de error relevante en OpenAPI:
- Crear schema `ApiErrorResponse`.
- Crear schema `ApiErrorDetail`.
- `ApiErrorResponse` debe requerir al menos `timestamp`, `status`, `error`, `code`, `message`, `path` y `trace_id`.
- `status` debe ser entero HTTP; `code` debe ser string estable de negocio/técnico. No usar `code` para el número HTTP.
- `details` debe ser arreglo, aunque pueda estar vacío.
- Reutilizar componentes para `BadRequest`, `Unauthorized`, `Forbidden`, `NotFound`, `Conflict`, `UnprocessableEntity`, `InternalServerError`.
- Cada endpoint debe declarar errores esperados, no solo `500`.
- La spec prose, OpenAPI y tests deben usar la misma forma. Cualquier diferencia de campos o tipos es blocker para Spec Validator.

## 7. Tests Obligatorios

Agregar tests para:
- DTO inválido retorna estructura estándar con `details`.
- JSON inválido retorna `400` estándar.
- recurso no encontrado retorna `404` estándar.
- conflicto de negocio retorna `409` estándar.
- excepción inesperada retorna `500` sin stack trace.
- `trace_id`, `path`, `status`, `code` y `message` siempre existen.
- Un controller que lanza `RuntimeException` no controlada retorna `500 INTERNAL_ERROR` con estructura estándar.
- No existe respuesta HTML/Whitelabel para errores REST.
- Las excepciones de seguridad (`401`, `403`) usan la misma estructura o un adaptador compatible documentado.

## 8. Prohibiciones

- No devolver strings sueltos como error.
- No devolver mapas ad hoc por controller.
- No exponer `exception.getMessage()` si contiene detalles internos.
- No mezclar estructuras de error distintas por endpoint.
- No usar `200` para representar errores funcionales.
- No repetir `try/catch` por controller para mapear excepciones a respuestas HTTP.
- No dejar excepciones no controladas fuera del advice global.
- No depender del error handler por defecto de Spring Boot para APIs REST.
