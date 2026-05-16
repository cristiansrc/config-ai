# Skill: OpenAPI & Global Error Standard (IDIOMA: ESPAÑOL)

Este skill define los estándares para el diseño de contratos OpenAPI y la unificación de respuestas de error en todo el ecosistema (Multi-Stack).

## 1. Diseño de Contratos (OpenAPI 3.1/4.0)
- **API-First**: El contrato `openapi.yaml` es la fuente de verdad absoluta.
- **Sincronización**: El agente Executor debe sincronizar `docs/api/openapi.yaml` con la ruta de recursos del stack activo.
- **Seguridad**: Todos los endpoints deben definir sus esquemas de seguridad (JWT, API Key) si aplican.

## 2. Estándar Global de Errores (RFC 9457)
Para garantizar la interoperabilidad, todas las respuestas que NO sean exitosas (4xx y 5xx) deben seguir el estándar **Problem Details for HTTP APIs**.

### Objeto de Error Maestro (`ProblemDetails`)
Todos los errores deben heredar o incluir esta estructura mínima en su respuesta:

```yaml
components:
  schemas:
    ProblemDetails:
      type: object
      description: Estructura universal para respuestas de error (RFC 9457).
      required:
        - type
        - title
        - status
        - detail
        - timestamp
        - path
      properties:
        type:
          type: string
          format: uri
          description: URI que identifica el tipo de problema.
          example: "https://api.tuempresa.com/errors/not-found"
        title:
          type: string
          description: Resumen breve del tipo de error.
          example: "Recurso no encontrado"
        status:
          type: integer
          description: Código de estado HTTP.
          example: 404
        detail:
          type: string
          description: Explicación detallada de esta ocurrencia específica.
          example: "El usuario con ID 123 no existe."
        timestamp:
          type: string
          format: date-time
          description: Instante UTC del error.
        path:
          type: string
          description: Endpoint donde ocurrió el error.
        traceId:
          type: string
          description: Identificador único de la petición para seguimiento.
        errors:
          type: array
          description: Detalles adicionales (errores de validación de campos).
          items:
            $ref: '#/components/schemas/ValidationError'
```

## 3. Comportamiento Obligatorio
1.  **Herencia de Errores**: En el `openapi.yaml`, todas las respuestas 4xx/5xx deben referenciar a `ProblemDetails` o usar `allOf` para extenderlo.
2.  **No Exceptions**: Queda prohibido devolver objetos de error personalizados que no sigan esta estructura (ej. evitar `{"message": "error"}`).
3.  **Content-Type**: Las respuestas de error deben usar preferiblemente `application/problem+json`.
4.  **Consistencia Multi-Stack**: 
    - En **Spring Boot**: Usar `ProblemDetail` nativo o el handler global definido en la skill `rest-error-response-standards`.
    - En **Node.js/Python**: Implementar un middleware/handler global que transforme cualquier excepción a este esquema exacto.

## 4. Validación de Contratos
- El Spec Validator debe marcar como **error** cualquier contrato que defina respuestas de error sin usar el esquema `ProblemDetails`.
