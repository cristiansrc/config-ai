---
name: pre-flight-check
description: Validación técnica obligatoria antes de realizar commits. Asegura que el código compile, pase tests y cumpla con las migraciones de base de datos en Docker.
---

# Pre-flight Check Skill

Esta skill convierte a los agentes en responsables de la estabilidad del repositorio.

## 1. Validación de Compilación y Calidad
Antes de usar la skill `git-ops` para hacer un commit, el agente debe ejecutar:
- **Gradle:** `./gradlew clean compileKotlin` (o `compileJava`).
- **Linter:** `./gradlew ktlintCheck` (o equivalente).

## 2. Validación de Persistencia (Flyway + Testcontainers)
Si la tarea involucra cambios en la base de datos o en las entidades:
- El agente debe ejecutar los tests de integración que utilicen Testcontainers: `./gradlew test --tests "*IntegrationTest*"`.
- **Regla:** Si la migración de Flyway falla en el entorno de prueba, el commit queda BLOQUEADO.

## 3. Protocolo de Fallo
Si un Pre-flight Check falla:
1. Analizar el log de error de Gradle/JUnit.
2. Aplicar la corrección necesaria.
3. Re-ejecutar la validación completa.
4. Solo tras un `BUILD SUCCESSFUL`, proceder al commit.

## 4. Eficiencia
Para ahorrar tiempo, el agente puede omitir el check completo solo si la tarea es puramente de documentación (`docs/`), pero nunca para cambios en `domain`, `application` o `infrastructure`.
