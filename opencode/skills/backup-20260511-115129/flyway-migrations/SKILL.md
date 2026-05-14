---
name: flyway-migrations
description: Gestión de base de datos PostgreSQL mediante migraciones incrementales con Flyway.
---

# Gestión de Base de Datos con Flyway

Uso de migraciones versionadas para garantizar la evolución segura y controlada del esquema de base de datos en PostgreSQL.

## Reglas de Nomenclatura
- Las migraciones deben seguir el formato: `V<VERSION>__<descripcion_breve>.sql` (ejemplo: `V1__create_users_table.sql`).
- Las versiones deben ser incrementales y únicas.

## Gestión del Esquema
- **Propiedad del Esquema**: El esquema de la base de datos es gestionado exclusivamente por Flyway. Nunca se debe permitir que JPA/Hibernate genere o modifique el esquema automáticamente (`ddl-auto` debe estar en `validate` o `none`).
- **Integridad**: Cada migración debe definir explícitamente:
    - Índices para columnas de búsqueda frecuente.
    - Claves foráneas (FKs) con sus respectivas restricciones.
    - Constraints de integridad (NOT NULL, UNIQUE, CHECK).
- Si una spec o task asume una columna, índice, constraint, enum o tabla, debe existir en una migración Flyway real o en una nueva migración pendiente definida explícitamente.
- No se permite marcar como consistente un cambio de esquema que solo existe en texto de spec/contexto pero no en un archivo de migración.
- Un mismatch entre spec y migraciones es blocker para Executor y Task Decomposer.
- La ruta de migraciones debe coincidir con la configuración Flyway real:
    - `src/main/resources/db/migration/` requiere ubicación classpath por defecto o `classpath:db/migration`.
    - `db/migration/` en la raíz del repo requiere configuración explícita `filesystem:db/migration`.
- Si el shared context dice que una migración fue creada en una ruta, esa ruta exacta debe existir. No se permite tratar `db/migration/` y `src/main/resources/db/migration/` como equivalentes.
- Si la migración vive en una ruta no estándar, la spec debe registrar la ruta y la configuración Flyway esperada en el `Decomposition Contract`.

## Buenas Prácticas
- Las migraciones son inmutables una vez aplicadas en entornos superiores.
- Para cambios en migraciones ya aplicadas, se debe crear una nueva migración incremental.
- Antes de generar tareas de aplicación/JPA, verificar con lectura real de `src/main/resources/db/migration/` que las migraciones esperadas existen.
- Si el proyecto usa otra ubicación, verificar con lectura real de esa ubicación y validar que Flyway la tenga configurada.
