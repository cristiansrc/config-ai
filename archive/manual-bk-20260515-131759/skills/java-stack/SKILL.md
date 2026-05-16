# Skill: Java Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones de rutas y mejores prácticas para proyectos basados en Java moderno (Java 21/25+).

## Convenciones de Rutas
- **Source Root**: `src/main/java`
- **Tests Root**: `src/test/java`
- **Packages**: Seguir convención de nombres en minúsculas (`com.empresa.proyecto`).

## Mejores Prácticas 2026
1.  **Records**: Usar `record` para todos los DTOs e inmutabilidad de datos.
2.  **Virtual Threads**: Priorizar el uso de Virtual Threads para tareas de I/O bloqueante (Project Loom). Evitar frameworks reactivos innecesarios.
3.  **Pattern Matching**: Usar `switch` expressions y pattern matching para desestructurar records y manejar jerarquías selladas (`sealed interfaces/classes`).
4.  **Scoped Values**: Usar `ScopedValue` en lugar de `ThreadLocal` para pasar contexto entre hilos de forma segura.

## Comportamiento Obligatorio
- El código generado debe ser idiomático de Java moderno, evitando verbosidad innecesaria (ej. usar `var` cuando el tipo sea evidente).

## Detección del Stack
- Si existen archivos `.java` o la estructura `src/main/java`, este skill se considera **ACTIVO**.
