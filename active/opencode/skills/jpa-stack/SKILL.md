---
name: jpa-stack
description: Estándares y mejores prácticas para el uso de Jakarta Persistence (JPA) e Hibernate en aplicaciones Java/Kotlin.
---

# Estándares JPA / Hibernate

Guía para una capa de persistencia robusta, eficiente y con soporte nativo para auditoría y borrado lógico.

## Configuración y Mapeo
- **Estrategia de Generación de ID**: Usar `GenerationType.IDENTITY` para MySQL/PostgreSQL o `GenerationType.SEQUENCE` para Oracle/PostgreSQL con secuencias dedicadas.
- **Lazy Loading**: Usar `FetchType.LAZY` en todas las relaciones (`@ManyToOne`, `@OneToOne`, etc.) para evitar el problema de N+1 consultas.
- **Naming Strategy**: Asegurar que Hibernate use `SnakeCasePhysicalNamingStrategy` para coincidir con los estándares de base de datos.
- **DTOs**: No exponer entidades en los controladores. Usar `Projection` o `DTOs` mediante `MapStruct` o constructores.

## Auditoría Automática
Usar `Spring Data Envers` o mecanismos nativos de `Spring Data JPA`:
- **Campos Estándar**:
    - `created_at`: `LocalDateTime` (not null, updatable = false).
    - `updated_at`: `LocalDateTime` (not null).
    - `created_by`: `String` (opcional, ID de usuario de Keycloak).
    - `updated_by`: `String` (opcional).
- **Implementación**:
    - Usar `@EntityListeners(AuditingEntityListener.class)`.
    - Marcar campos con `@CreatedDate`, `@LastModifiedDate`, `@CreatedBy`, `@LastModifiedBy`.
    - Habilitar `@EnableJpaAuditing` en la configuración de Spring.

## Borrado Lógico (Soft Delete)
Para evitar la eliminación física y automatizar el filtrado de registros activos:
- **Campo**: `deleted` (Boolean, default false) o `deleted_at` (Timestamp, null por defecto).
- **Anotaciones en la Entidad**:
    ```java
    @SQLDelete(sql = "UPDATE table_name SET deleted = true WHERE id = ?")
    @Where(clause = "deleted = false")
    public class MyEntity { ... }
    ```
- **Consecuencias**:
    - `repository.delete(entity)` ejecutará un `UPDATE` en lugar de un `DELETE`.
    - `repository.findAll()` y búsquedas por ID filtrarán automáticamente registros donde `deleted = true`.
- **Bypass**: Si se requiere consultar datos eliminados por auditoría, usar una query nativa o deshabilitar temporalmente el filtro de Hibernate mediante la sesión.

## Consultas y Rendimiento
- **JPQL/HQL**: Preferir sobre SQL nativo para mantener la portabilidad.
- **Entity Graphs**: Usar `@EntityGraph` para inicializar relaciones específicas de forma eficiente sin recurrir a EAGER global.
- **ReadOnly**: Usar `@Transactional(readOnly = true)` en métodos de consulta para optimizar el rendimiento de la sesión de Hibernate (deshabilita el dirty checking).
- **Paginación**: Usar siempre `Pageable` y `Page<T>` en métodos que retornen colecciones grandes.
