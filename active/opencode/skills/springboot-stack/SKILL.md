# Skill: Spring Boot Framework Convention (IDIOMA: ESPAÑOL)

Este skill define convenciones de framework para proyectos basados en Spring Boot. No define estilo de lenguaje, boilerplate, DTOs ni estrategia de mapeo de objetos; esas decisiones pertenecen a `java-stack` o `kotlin-stack` segun el lenguaje activo.

## Convenciones de Recursos
- **Resources**: `src/main/resources`
- **OpenAPI Runtime**: `src/main/resources/openapi.yaml`
- **Database Migrations (Flyway)**: `src/main/resources/db/migration`

## Mejores Prácticas Spring Boot 2026
1.  **Configuración del Framework**: Usar `application.yaml` por perfil (`application-local.yaml`, `application-test.yaml`, etc.) y evitar `.properties` salvo compatibilidad existente.
2.  **Constructor Injection**: Usar siempre inyección por constructor sobre `@Autowired` en campos.
3.  **Web/API Layer**: Mantener controllers delgados; delegar lógica a casos de uso/servicios de aplicación siguiendo arquitectura hexagonal.
4.  **Error Handling**: Usar `@RestControllerAdvice` para centralizar el manejo de excepciones, alineado con `springboot-java-rest-error-response-standards` o `springboot-kotlin-rest-error-response-standards` segun el lenguaje activo.
5.  **Observability**: Integrar Actuator, Micrometer y OpenTelemetry para health checks, métricas y trazas.
6.  **Transacciones**: Declarar `@Transactional` en boundaries de aplicación/servicio, no en controllers.

## Comportamiento Obligatorio
1.  **Sincronización**: El agente Executor debe asegurar que `docs/api/openapi.yaml` se copie a `src/main/resources/openapi.yaml` si hay cambios.
2.  **Flyway**: Las migraciones siempre se buscan en `src/main/resources/db/migration`.
3.  **Configuración**: Preferir archivos `.yaml` sobre `.properties`.
4.  **Separación de Responsabilidades**: No introducir reglas de Lombok, MapStruct, records, data classes, coroutines ni estilo de lenguaje en este skill. Consultar `java-stack` o `kotlin-stack`.

## Detección del Stack
- Si el archivo `build.gradle`, `build.gradle.kts` o `pom.xml` está presente y contiene dependencias de Spring Boot, este skill se considera **ACTIVO**.
