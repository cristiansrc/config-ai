# Skill: FastAPI Stack Convention (IDIOMA: ESPANOL)

Este skill define las convenciones especificas para el desarrollo de APIs rapidas y modernas con FastAPI.

## Estandares Tecnicos
- **Asincronia**: Uso obligatorio de `async def` para endpoints y operaciones de I/O.
- **Inyeccion de Dependencias**: Usar el sistema nativo de `Depends` para servicios, bases de datos y seguridad.
- **Pydantic V2**: Validacion estricta de schemas de entrada/salida en el borde HTTP. No usar schemas de API como dominio por defecto.

## Estructura de Endpoints
- Usar `APIRouter` por modulo/entidad.
- Definir `response_model` en cada decorador para asegurar el contrato de salida.
- Manejo de excepciones mediante `exception_handler` globales que cumplan con `fastapi-rest-error-response-standards`.
- Convertir request models a application commands/queries antes de llamar use cases.
- Convertir domain/application results a response models en el router o mapper del adapter HTTP.
- No pasar `Request`, `Depends`, `HTTPException`, `BackgroundTasks`, Pydantic request models ni ORM sessions al dominio.

## Persistencia
- Default: `SQLAlchemy 2.x` como ORM de persistencia, con `AsyncSession` si el stack es async.
- Migraciones: `Alembic` como mecanismo de versionado del schema.
- Las entidades ORM pertenecen a infraestructura; no usarlas como dominio.
- Los repositorios deben vivir como adapters de salida y mapear entre ORM models y domain/application results.
- `Tortoise` u otro ORM async solo si el proyecto ya lo eligio y queda documentado como excepcion.
- No filtrar `Session`, `AsyncSession`, `Query`, `select()` o builders de SQL hacia application/domain.
- Los tests de persistencia deben validar mappings, queries criticas, constraints y transacciones.

## Estructura de Persistencia
- `app/infrastructure/persistence/models`: ORM models.
- `app/infrastructure/persistence/repositories`: adapters de repositorio.
- `app/infrastructure/persistence/mappers`: conversion entre ORM y modelos internos.
- `migrations/`: Alembic.

## Comportamiento del Agente
- El Executor debe generar documentacion automatica de Swagger habilitando `/docs` en desarrollo.
- Se debe configurar `CORSMiddleware` si el proyecto tiene un frontend asociado.
