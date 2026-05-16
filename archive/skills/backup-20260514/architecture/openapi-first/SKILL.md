---
name: openapi-first
description: Flujo API Design First con generación de código automática en Gradle.
---

# OpenAPI First Design

Este flujo de trabajo prioriza el diseño del contrato de la API antes de la implementación, asegurando consistencia entre el servidor y los clientes.

## Directrices de Diseño
- **Fuente de Verdad**: La ruta OpenAPI canonica del proyecto debe estar declarada en la spec/shared context y verificada leyendo el archivo real. Para Spring Boot, se aceptan por defecto `docs/api/openapi.yaml`, `docs/api/openapi.yml`, `src/main/resources/openapi.yaml` o `src/main/resources/openapi.yml`.
- Cualquier cambio en la interfaz debe realizarse primero en el archivo OpenAPI canonico. Planner es el dueño de editar OpenAPI; otros agentes deben detenerse y reportar drift.
- **Generación de Código**: Se utiliza el plugin `org.openapi.generator` en Gradle para generar automáticamente las interfaces de los controladores y los modelos DTO.
- **Configuración del Generador**: La propiedad `interfaceOnly: true` debe estar activada para generar solo las interfaces, obligando a los desarrolladores a implementar la lógica en los controladores de la capa de infraestructura.
- No se permite implementar ni descomponer tareas de endpoints si OpenAPI está en drift frente a la spec validada.
- Todos los códigos de error, headers, request/response schemas, security requirements y side effects visibles al cliente deben estar en OpenAPI antes de implementación.
- Un drift OpenAPI/spec es blocker, no deuda técnica post-incremento.
- Si una skill de errores REST está activa, OpenAPI debe documentar el mismo schema de error que la spec. No se permite que la spec use una forma y OpenAPI otra.
- Para APIs Spring Boot con `rest-error-response-standards`, el schema de error debe incluir `timestamp`, `status`, `error`, `code`, `message`, `path`, `trace_id` y `details`.
- El campo `code` es un código estable de negocio/técnico tipo string; el HTTP status numérico vive en `status`.
- Si el flujo transaccional visible al cliente difiere entre spec y OpenAPI, por ejemplo DB-first versus identity-provider-first, detener con `Blocked: OpenAPI/spec transaction drift`.

## Implementación
- **Controladores**: Los controladores web en `infrastructure` deben implementar las interfaces generadas por OpenAPI.
- **Segregación de Modelos**: Los DTOs definidos en el contrato son exclusivos para la comunicación externa. No deben utilizarse como entidades de dominio ni de persistencia.
- **Validación**: Las anotaciones de validación (Bean Validation) generadas a partir del contrato deben respetarse rigurosamente.
- **Gate**: Si el OpenAPI canonico no existe, no valida, o contradice la spec activa, detener y devolver `Blocked: OpenAPI contract not ready`.
- **Gate de evidencia**: Antes de aprobar descomposición, registrar endpoints, schemas y respuestas verificadas desde el archivo OpenAPI real, no desde un resumen de chat.
