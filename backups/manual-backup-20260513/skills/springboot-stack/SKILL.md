# Skill: Spring Boot Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones de configuración y comportamiento para proyectos basados en Spring Boot.

## Convenciones de Recursos
- **Resources**: `src/main/resources`
- **OpenAPI Runtime**: `src/main/resources/openapi.yaml`
- **Database Migrations (Flyway)**: `src/main/resources/db/migration`

## Mejores Prácticas Spring 2026
1.  **Virtual Threads**: Habilitar `spring.threads.virtual.enabled=true` por defecto en proyectos Java.
2.  **Constructor Injection**: Usar siempre inyección por constructor sobre `@Autowired` en campos.
3.  **Observability**: Integración nativa con Micrometer y OpenTelemetry para trazas y métricas.
4.  **Error Handling**: Usar `@RestControllerAdvice` para centralizar el manejo de excepciones (Alineado con skill `rest-error-response-standards`).

## Comportamiento Obligatorio
1.  **Sincronización**: El agente Executor debe asegurar que `docs/api/openapi.yaml` se copie a `src/main/resources/openapi.yaml` si hay cambios.
2.  **Flyway**: Las migraciones siempre se buscan en `src/main/resources/db/migration`.
3.  **Configuración**: Preferir archivos `.yaml` sobre `.properties`.

## Detección del Stack
- Si el archivo `build.gradle`, `build.gradle.kts` o `pom.xml` está presente y contiene dependencias de Spring Boot, este skill se considera **ACTIVO**.
