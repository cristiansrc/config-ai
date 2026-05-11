---
name: repository-dto-patterns
description: Estandarización de acceso a datos y transferencia de objetos en Spring Boot. Desacopla la base de datos de la lógica de negocio.
---

# Repository and DTO Patterns

Esta skill define cómo gestionar la persistencia y la transferencia de datos entre capas.

## 1. Repositories
- Usar Spring Data JPA Interfaces en la capa de infraestructura.
- No exponer entidades JPA fuera de la capa de infraestructura.
- Los puertos del dominio deben devolver modelos de dominio, no entidades JPA.

## 2. DTOs
- **Inmutabilidad:** Usar `Records` en Java 21+ y `Data Classes` en Kotlin.
- **Validación:** Aplicar anotaciones de `jakarta.validation` en los DTOs que vienen de la API.
- **Desacoplamiento:** Los DTOs de la API son generados por OpenAPI y viven en su propio paquete.

## 3. Mapeo
- **Java:** Usar MapStruct para conversiones entre `Entity <-> Domain` y `Domain <-> DTO`.
- **Kotlin:** Usar funciones de extensión (extension functions) o constructores para el mapeo.
- **Naming:** Mantener consistencia en los nombres de los campos para facilitar el mapeo automático.
