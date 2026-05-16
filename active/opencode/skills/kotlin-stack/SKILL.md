# Skill: Kotlin Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones de rutas y mejores prácticas para proyectos basados en Kotlin moderno (Kotlin 2.x+).

## Convenciones de Rutas
- **Source Root**: `src/main/kotlin`
- **Tests Root**: `src/test/kotlin`
- **Packages**: Seguir convención de nombres en minúsculas.

## Mejores Prácticas 2026
1.  **Coroutines**: Uso obligatorio de `suspend functions` y `coroutineScope` para asincronía. Evitar bloqueos de hilo.
2.  **KSP2**: Usar Kotlin Symbol Processing (KSP) v2 para cualquier procesamiento de anotaciones o generación de código.
3.  **Kotlin Serialization**: Preferir `kotlinx.serialization` sobre Jackson para máxima compatibilidad con tipos de Kotlin y K2.
4.  **Inmutabilidad**: Usar `val` y `data classes` por defecto.
5.  **Context Parameters**: Usar parámetros de contexto (Kotlin 2.2+) para inyectar dependencias de forma implícita y limpia.

## Comportamiento Obligatorio
- El código generado debe aprovechar las características de Kotlin (extension functions, null-safety, named arguments). No debe parecer "Java escrito en Kotlin".

## Detección del Stack
- Si existen archivos `.kt` o `.kts`, o la estructura `src/main/kotlin`, este skill se considera **ACTIVO**.
