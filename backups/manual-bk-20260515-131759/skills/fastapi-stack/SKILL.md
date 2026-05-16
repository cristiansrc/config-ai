# Skill: FastAPI Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones específicas para el desarrollo de APIs rápidas y modernas con FastAPI.

## Estándares Técnicos
- **Asincronía**: Uso obligatorio de `async def` para endpoints y operaciones de I/O.
- **Inyección de Dependencias**: Usar el sistema nativo de `Depends` para servicios, bases de datos y seguridad.
- **Pydantic V2**: Validación estricta de Schemas (Input/Output).

## Estructura de Endpoints
- Usar `APIRouter` por módulo/entidad.
- Definir `response_model` en cada decorador para asegurar el contrato de salida.
- Manejo de excepciones mediante `exception_handler` globales que cumplan con la skill `openapi-standard`.

## Comportamiento del Agente
- El Executor debe generar documentación automática de Swagger habilitando `/docs` en desarrollo.
- Se debe configurar `CORSMiddleware` si el proyecto tiene un frontend asociado.
