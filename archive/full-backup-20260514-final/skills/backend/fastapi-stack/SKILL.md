---
name: fastapi-stack
description: Estándares y mejores prácticas para FastAPI alineados con Arquitectura Hexagonal y OpenAPI.
---

# Estándares FastAPI

Guía para la implementación de APIs de alto rendimiento con FastAPI y Arquitectura Hexagonal.

## Pruebas y Cobertura
- **Herramientas**: `pytest`, `httpx` (para TestClient), `pytest-asyncio`.
- **Cobertura**: Usar `pytest-cov`.
- **Exclusiones**: Configurar en `pyproject.toml` o `.coveragerc` para ignorar:
    - `app/schemas/*` (equivalente a DTOs)
    - `app/core/config.py`
    - `app/models/*` (si solo son modelos SQLAlchemy/Tortoise)
    - `app/exceptions.py`
- **Umbral**: Configurar `--cov-fail-under=85` para asegurar el mínimo del **85%** de cobertura por archivo.

## Arquitectura Hexagonal en FastAPI
A diferencia de Spring Boot, en FastAPI la arquitectura es más ligera pero sigue los mismos principios:

### 1. Dominio (`app/domain`)
- Modelos de dominio usando **Pydantic V2** (agnósticos de base de datos).
- Excepciones de dominio personalizadas.
- Interfaces (Abstract Base Classes - `abc.ABC`) para los puertos.

### 2. Aplicación (`app/application`)
- Casos de uso como funciones `async def` o clases de servicio.
- Orquestación de lógica y puertos de salida.

### 3. Infraestructura (`app/infrastructure`)
- **Adapters In**: Routers de FastAPI (`APIRouter`).
- **Adapters Out**: Implementaciones de repositorios (SQLAlchemy/Tortoise), clientes HTTP (HTTPX).
- **Mappers**: Conversión manual o mediante funciones entre Pydantic (Dominio) y SQLAlchemy (Entidad).

## Manejo Global de Errores (Controller Advice)
Fastapi usa `exception_handlers`. Se debe definir un handler global para asegurar consistencia con `rest-error-response-standards`:

```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

@app.exception_handler(BusinessException)
async def business_exception_handler(request: Request, exc: BusinessException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "status": exc.status_code,
            "error": exc.error_name,
            "code": exc.code,
            "message": exc.message,
            "path": request.url.path,
            "trace_id": request.state.trace_id,
            "details": exc.details
        }
    )
```

## Mejores Prácticas RESTful y OpenAPI
- **Pydantic**: Usar alias en Pydantic si se requiere `snake_case` interno y `camelCase` externo, pero el estándar del proyecto prefiere **`snake_case`** global según `restful-standard`.
- **Dependency Injection**: Usar `Depends` de FastAPI para inyectar casos de uso en los routers.
- **Async**: Usar siempre `async def` para endpoints y operaciones de I/O (BD, APIs externas).
- **Security**: Usar los esquemas integrados de FastAPI para OAuth2/OpenID Connect (alineado con `keycloak-standard`).
- **OpenAPI**: FastAPI genera el contrato automáticamente. Asegurar que las respuestas de error estén documentadas usando el parámetro `responses` en los decoradores de los endpoints.

## Auditoría y Soft Delete
- Aplicar los principios de `jpa-stack` adaptados a SQLAlchemy:
    - Mixins para campos `created_at`, `updated_at`, `deleted`.
    - Uso de "Session Events" o "Global Filters" para implementar Soft Delete automático.
