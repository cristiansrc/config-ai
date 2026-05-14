---
name: postgresql-standard
description: Estándares y mejores prácticas para el diseño y gestión de bases de datos PostgreSQL.
---

# Estándares PostgreSQL

Guía para el uso eficiente de PostgreSQL en arquitecturas modernas.

## Tipos de Datos y Naming
- **Naming**: `snake_case` para tablas, columnas, índices y constraints.
- **IDs**: Usar `BIGSERIAL` para IDs autoincrementales o `UUID` si se requiere descentralización.
- **Strings**: Preferir `VARCHAR(n)` con límites razonables o `TEXT` para contenido sin límite.
- **JSON**: Usar siempre `JSONB` en lugar de `JSON` para mejor rendimiento y soporte de índices.
- **Booleans**: Usar tipo `BOOLEAN` nativo.

## Índices y Rendimiento
- **B-Tree**: Por defecto para comparaciones de igualdad y rango.
- **GIN**: Obligatorio para columnas `JSONB` y arrays.
- **Partial Indexes**: Usar para filtrar nulos o estados comunes (ej: `WHERE active IS TRUE`).
- **Explain**: Usar `EXPLAIN ANALYZE` para diagnosticar queries lentas.

## Integridad y Seguridad
- **Constraints**: Definir siempre `NOT NULL` donde aplique. Usar `CHECK` para validaciones de dominio simples (ej: `price > 0`).
- **Enums**: Usar tipos `ENUM` nativos de Postgres para valores estáticos que raramente cambian.
- **Schemas**: Organizar objetos en esquemas lógicos si la base de datos es compartida.

## Mejores Prácticas
- Evitar `SELECT *`; listar columnas explícitamente.
- Usar `CTE` (Common Table Expressions) con `WITH` para legibilidad en queries complejas.
- Configurar `timezone` a `UTC` a nivel de base de datos.
- Usar `timestamptz` para fechas con zona horaria.
