---
name: restful-standard
description: Estándares y mejores prácticas para el diseño de APIs RESTful, alineados con OpenAPI 3.1 y Clean Architecture.
---

# Estándares RESTful

Guía para el diseño de interfaces consistentes, intuitivas y alineadas con los estándares de la industria.

## Recursos y Naming
- **Sustantivos, no verbos**: Las rutas deben representar recursos (ej: `/users`, no `/getUsers`).
- **Pluralización**: Usar siempre plural para las colecciones (ej: `/orders`, `/products`).
- **Case**: Usar `kebab-case` para las rutas de la URL (ej: `/payment-methods`).
- **Case de Atributos**: Usar `snake_case` para los atributos en el cuerpo del JSON (coherente con el estándar de base de datos).
- **Consistencia**: Un recurso debe tener el mismo nombre en la URL, en el schema de OpenAPI y en el dominio (si aplica).

## Verbos HTTP y Semántica
- `GET`: Recuperar recursos. Idempotente y seguro.
- `POST`: Crear nuevos recursos o realizar acciones que no son CRUD (ej: `/orders/1/calculate-shipping`).
- `PUT`: Actualizar un recurso existente de forma completa. Idempotente.
- `PATCH`: Actualización parcial de un recurso.
- `DELETE`: Eliminación lógica (soft delete) según el estándar del proyecto. Idempotente.

## Status Codes Estándar
- **200 OK**: Éxito en `GET`, `PUT`, `PATCH`.
- **201 Created**: Éxito en `POST` de creación. Debe incluir el header `Location`.
- **204 No Content**: Éxito en `DELETE`.
- **400 Bad Request**: Errores de validación o lógica de negocio.
- **401 Unauthorized**: Falta de autenticación.
- **403 Forbidden**: Autenticado pero sin permisos para el recurso.
- **404 Not Found**: El recurso no existe.
- **500 Internal Server Error**: Errores no controlados.

## Paginación, Filtrado y Sorteo
- **Paginación**: Usar query params `page` y `size`.
- **Sorteo**: Usar query param `sort` (ej: `sort=created_at,desc`).
- **Filtrado**: Usar query params directos (ej: `status=active&category=electronics`).

## Integración con OpenAPI
- Cada endpoint definido en OpenAPI debe seguir estas reglas de nombrado y semántica.
- Los esquemas de error documentados en OpenAPI deben coincidir con el estándar de `rest-error-response-standards`.
- Usar `tags` en OpenAPI para agrupar recursos relacionados.
- Definir `operationId` descriptivos y únicos (ej: `findOrderById`, `createNewProduct`).

## Seguridad
- No exponer IDs internos si es posible (usar UUIDs para URLs públicas).
- Validar siempre el Content-Type (`application/json`).
- Documentar los requisitos de seguridad (`securitySchemes`) en OpenAPI (ver `keycloak-standard`).
