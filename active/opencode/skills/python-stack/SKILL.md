# Skill: Python Stack Convention (IDIOMA: ESPANOL)

Este skill define las convenciones de rutas y arquitectura para proyectos Python (FastAPI) con Arquitectura Hexagonal.

## Estructura de Carpetas (Hexagonal)
- **Domain**: `app/domain/` (entidades, value objects, dataclasses/clases simples y logica central; sin FastAPI, SQLAlchemy ni Pydantic de transporte).
- **Application**: `app/application/` (Servicios, casos de uso e interfaces de puertos).
- **Infrastructure**: `app/infrastructure/` (Adaptadores de base de datos, clientes externos, ORM models, sessions y mappers).
- **Entrypoints**: `app/web/` o `app/api/` (Routers de FastAPI y dependencias).

## Convenciones de Rutas
- **OpenAPI Runtime**: `app/infrastructure/web/openapi.yaml`.
- **Persistencia ORM**: `SQLAlchemy 2.x` como default para acceso a base de datos.
- **Migrations**: `migrations/` (Alembic).
- **Tests Root**: `tests/` utilizando Pytest.

## Comportamiento Obligatorio
1.  **Pydantic V2**: Usar Pydantic para DTOs de entrada/salida, settings y payloads de integracion; no usarlo automaticamente como dominio cuando haya logica de negocio.
2.  **Sincronizacion**: El Executor debe sincronizar el OpenAPI desde `docs/api/` a la ruta de infraestructura de la aplicacion.
3.  **Dependency Injection**: Usar el sistema de inyeccion de FastAPI para desacoplar puertos de adaptadores.
4.  **Mapping explicito**: Convertir Pydantic request/response models, ORM models y domain models mediante funciones pequenas y testeables siguiendo `repository-dto-patterns`.
5.  **Persistencia**: Usar `SQLAlchemy 2.x` + `Alembic` como default. Si la aplicacion es async, preferir `AsyncSession`; si es sync, usar `Session` de forma consistente.

## Modelos y Mapeo
- Dominio: clases simples, `dataclass` o value objects propios cuando haya reglas de negocio.
- API DTOs: Pydantic `BaseModel` en `app/api`, `app/web` o paquete equivalente de adapters.
- Persistencia: SQLAlchemy models, sessions, repositories y queries en infraestructura. Tortoise solo si el proyecto ya lo usa y queda declarado como excepcion.
- No pasar `BaseModel`, `Session`, `AsyncSession`, ORM models, `Request`, `Depends` ni `HTTPException` hacia dominio.
- Evitar `model_dump()` + `**kwargs` para mappings criticos si hay semantica, nullability, enum, fechas, dinero o permisos involucrados.
- No existe equivalente directo a MapStruct en Python como estandar del stack; preferir funciones explicitas y tests.

## Deteccion del Stack
- Si existe `pyproject.toml`, `requirements.txt` o `setup.py`, este skill se considera **ACTIVO**.
