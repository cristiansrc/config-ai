# Skill: Python Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones de rutas y arquitectura para proyectos Python (FastAPI) con Arquitectura Hexagonal.

## Estructura de Carpetas (Hexagonal)
- **Domain**: `app/domain/` (Modelos Pydantic y lógica central).
- **Application**: `app/application/` (Servicios, casos de uso e interfaces de puertos).
- **Infrastructure**: `app/infrastructure/` (Adaptadores de base de datos, clientes externos).
- **Entrypoints**: `app/web/` o `app/api/` (Routers de FastAPI y dependencias).

## Convenciones de Rutas
- **OpenAPI Runtime**: `app/infrastructure/web/openapi.yaml`.
- **Migrations**: `migrations/` (Alembic).
- **Tests Root**: `tests/` utilizando Pytest.

## Comportamiento Obligatorio
1.  **Pydantic V2**: Uso estricto de Pydantic para validación de datos.
2.  **Sincronización**: El Executor debe sincronizar el OpenAPI desde `docs/api/` a la ruta de infraestructura de la aplicación.
3.  **Dependency Injection**: Usar el sistema de inyección de FastAPI para desacoplar puertos de adaptadores.

## Detección del Stack
- Si existe `pyproject.toml`, `requirements.txt` o `setup.py`, este skill se considera **ACTIVO**.
