---
name: flyway-migrations
description: Gestión de esquemas de base de datos mediante migraciones incrementales con Flyway. Compatible con PostgreSQL, MySQL, Oracle y SQL Server.
---

# Gestión de Base de Datos con Flyway

Uso de migraciones versionadas y repetibles para garantizar la evolución segura y controlada del esquema de base de datos.

## Detección del Stack

- Si el archivo `build.gradle`, `build.gradle.kts` o `pom.xml` contiene la dependencia `flyway-core` o `flyway-maven-plugin`, este skill se considera **ACTIVO**.
- Para proyectos Python/FastAPI con Alembic, este skill **NO aplica**; usar `fastapi-stack` con SQLAlchemy + Alembic.

## Tipos de Migraciones

- **Versionadas (V)**: `V<VERSION>__<descripcion>.sql`. Evolución del esquema. Se ejecutan exactamente una vez. **Inmutables** una vez aplicadas en cualquier ambiente.
- **Repetibles (R)**: `R__<descripcion>.sql`. Para vistas, procedures y funciones. Se reejecutan cuando cambia su checksum.
- **Undo (U)**: `U<VERSION>__<descripcion>.sql`. **Prohibido en producción**. Solo se permiten en ambientes de desarrollo local para iteración rápida. En producción, crear una migración V nueva que revierta el cambio.

## Reglas de Nomenclatura y Estructura

- **Formato**: `V1.0.1__create_users_table.sql`. Usar puntos para subversiones. Separador `__` (doble guion bajo) entre versión y descripción.
- **Descripción**: Usar kebab-case o snake_case descriptivo (ej: `create_users_table`, `add_status_to_orders`).
- **Ubicación canónica**: `src/main/resources/db/migration/`. Si el proyecto usa `filesystem:db/migration`, la ruta es `db/migration` en la raíz del proyecto. Verificar la configuración real antes de asumir la ruta.
- **Conflictos de versión**: Si dos desarrolladores crean la misma versión, la segunda migración fallará al aplicar. Resolver aumentando la versión (ej: `V1.0.2` en lugar de `V1.0.1` ya tomada). **Prohibido** modificar una migración ya aplicada para cambiar su número de versión.
- **Separación DDL/DML**: Preferir migraciones puramente DDL para cambios de esquema. Si se necesita insertar datos de referencia, usar una migración separada con sufijo `_data` (ej: `V1.0.2__seed_status_data.sql`).

## Gestión del Esquema

- **Propiedad del Esquema**: Flyway es el único dueño del esquema de base de datos. `spring.jpa.hibernate.ddl-auto` debe ser `validate` o `none`. Ver `jpa-stack`.
- **Baseline**: Para bases de datos existentes que se incorporan a Flyway, usar `baselineOnMigrate=true` con una migración `V1__baseline.sql` que represente el estado actual.
- **Integridad**: Definir explícitamente Índices, FKs, NOT NULL, UNIQUE y CHECK constraints en las migraciones DDL.
- **Bloqueo de Tareas**: Cualquier cambio de esquema mencionado en specs DEBE existir como archivo de migración real antes de pasar a `executor`.
- **Consistencia de Rutas**: Verificar la ruta configurada en el proyecto (`classpath:` vs `filesystem:`) antes de crear o buscar migraciones.

## Configuración Recomendada

- **Propiedades mínimas** (Spring Boot):
  ```yaml
  spring:
    flyway:
      enabled: true
      locations: classpath:db/migration
      baseline-on-migrate: false  # true solo para bases de datos existentes
      validate-on-migrate: true
  ```
- **Perfiles**: En `application-dev.yml`, permitir `out-of-order` para desarrollo paralelo. En `application-prod.yml`, `out-of-order: false` y `validate-on-migrate: true`.

## Mejores Prácticas

- **Transaccionalidad**: Cada migración V se ejecuta en una transacción (si el motor lo soporta). Evitar mezclar DDL y DML en motores que no soportan DDL transaccional (MySQL con ciertos objetos, Oracle).
- **Callbacks**: Usar SQL callbacks (`beforeMigrate.sql`, `afterMigrate.sql`) solo para configuración de entorno, no para lógica de negocio.
- **Checksums**: Si hay errores de validación de checksums, **nunca** modificar el archivo de migración ya aplicado. Usar `flyway repair` solo para actualizar la tabla de historial cuando se ha corregido la inconsistencia deliberadamente.
- **Vendor Specifics**: Consultar las skills específicas del motor para tipos de datos, índices y optimizaciones:
    - `postgresql-standard`
    - `mysql-standard`
    - `oracle-standard`
    - `sqlserver-standard`

## Pruebas y Verificación

- **Herramientas**: Testcontainers para levantar una instancia de BD real y ejecutar migraciones en CI.
- **Test de migraciones**: Verificar que `flyway migrate` ejecuta sin errores y que `flyway validate` pasa después de cada cambio.
- **Test de idempotencia (R scripts)**: Los scripts R deben poder ejecutarse múltiples veces sin errores. Probar con `flyway migrate` dos veces consecutivas.
- **Pre-vuelo**: Antes de implementar lógica de persistencia, leer físicamente el directorio de migraciones para confirmar la existencia de los artefactos esperados.

## Comportamiento Obligatorio

1. Flyway es la única fuente de verdad del esquema. Prohibido usar `ddl-auto=create` o `ddl-auto=update` en cualquier ambiente.
2. Toda migración V es inmutable una vez aplicada. Prohibido editar una migración ya aplicada.
3. Las migraciones de datos (seed/DML) se separan de las de esquema (DDL).
4. Verificar la ruta real configurada antes de crear o buscar migraciones (`classpath:db/migration` vs `filesystem:db/migration`).