---
name: pre-flight-check
description: Validación técnica obligatoria antes de cerrar tareas, aprobar incrementos o realizar commits. Exige evidencia real de filesystem, build, tests, cobertura, migraciones y servicios cuando aplique.
---

# Pre-flight Check Skill

Esta skill convierte a los agentes en responsables de la estabilidad verificable del repositorio. No basta con afirmar que algo "debería compilar" o que "los tests deberían pasar": el agente debe ejecutar o reportar explícitamente la verificación aplicable.

## 1. Cuándo Aplica
Ejecutar pre-flight antes de:
- Marcar una tarea como `done`.
- Entregar implementación, refactor o tests.
- Ejecutar `git-ops` para commit/PR.
- Solicitar `final-validation`.
- Declarar que un incremento está listo para producción.

## 2. Evidencia Mínima Obligatoria
Cada pre-flight debe registrar:
- Comandos ejecutados.
- Directorio desde donde se ejecutaron.
- Resultado observado (`pass`, `fail`, `blocked`, `skipped-with-reason`).
- Resumen del output relevante.
- Archivos o módulos cubiertos por la verificación.
- Razón explícita si una verificación no pudo ejecutarse.

## 3. Verificaciones Por Stack
 
### Spring Boot / Java / Kotlin
- Build/compile: `./gradlew clean test` o `./mvnw clean test` según el proyecto.
- Compile rápido si el repo es grande: `./gradlew compileJava`, `./gradlew compileKotlin` o `./mvnw test -DskipTests` solo como check intermedio, nunca como única verificación final.
- Lint/format si existe: `./gradlew ktlintCheck`, `./gradlew checkstyleMain`, `./gradlew spotlessCheck`, `./mvnw spotless:check` o comando equivalente del proyecto.
- **Doctor/Auditoría de Arquitectura y Lenguaje (ArchUnit & detekt):** Es obligatorio que la suite de pruebas unitarias incluya la validación de arquitectura de `ArchUnit` para verificar las dependencias de paquetes de la arquitectura hexagonal. Adicionalmente, ejecutar `./gradlew detekt` en proyectos Kotlin para verificar smells de código.
- Cobertura si está configurada: `./gradlew jacocoTestReport jacocoTestCoverageVerification` o equivalente Maven.
 
### Persistencia / Flyway / Testcontainers
Si la tarea cambia migraciones, entidades, repositorios, queries, índices o config de DB:
- Ejecutar tests de integración relevantes, por ejemplo `./gradlew test --tests "*IntegrationTest*"` o el comando definido por el proyecto.
- Verificar que Flyway aplica migraciones desde la ruta real configurada (`src/main/resources/db/migration`, `db/migration` con `filesystem:`, u otra ruta explícitamente).
- Si Flyway o Testcontainers falla, el cierre queda `blocked`.
 
### Node.js / React / Angular
- Usar `pnpm`, no `npm`.
- Instalar/verificar dependencias solo si el proyecto lo requiere y está permitido por el entorno.
- Ejecutar según scripts existentes: `pnpm test`, `pnpm run lint`, `pnpm run typecheck`, `pnpm run build`, `pnpm run coverage`.
- **Doctor/Auditoría de Frontend (React Doctor & Angular ESLint):**
  - **React:** Si el proyecto usa React, es obligatorio ejecutar `npx -y react-doctor@latest .` antes de realizar el push. El score resultante debe ser mayor o igual a **85/100**.
  - **Angular:** Ejecutar `npm run lint` validando las reglas estrictas de RxJS y señales (`eslint-plugin-rxjs`) para evitar fugas de memoria.
- Si existe `package-lock.json`, detener y proponer migración a `pnpm-lock.yaml` antes de continuar.
 
### Python / FastAPI
- Ejecutar tests: `pytest`.
- Cobertura si está configurada: `pytest --cov` o comando del proyecto.
- **Doctor/Auditoría de Código (Ruff & Mypy):** Ejecutar obligatoriamente `ruff check .` y `mypy app/` (tipado estricto). No se permite pasar el pre-flight si hay errores de tipos reportados por Mypy en las firmas de FastAPI o Pydantic.
 
### Go / Golang
- Ejecutar tests: `go test ./...`.
- Cobertura si está configurada: `go test -coverprofile=coverage.out ./...`.
- **Doctor/Auditoría de Arquitectura (golangci-lint):** Ejecutar obligatoriamente `golangci-lint run`. Debe verificar las reglas de `depguard` y `go-cleanarch` para validar que no haya imports cruzados prohibidos entre `domain`, `application` y `adapters`.

### Docker / DevOps / n8n
- Si cambian `Dockerfile`, `docker-compose.yml`, infraestructura o workflows, ejecutar validación equivalente: `docker compose config`, build de imagen, health checks locales o export/validación de workflow.
- No aprobar cambios de despliegue sin validar que no exponen secretos, puertos inseguros o contenedores root cuando el estándar lo prohíbe.
 
### Auditoría de Calidad Global (Sonar Local)
- Si el proyecto tiene configurado Sonar localmente, ejecutar el escaneo mediante `sonar-scanner` o el comando configurado. El pre-flight fallará localmente si se introducen nuevas issues de severidad *Bloqueante* o *Crítica*.

### Grafo de Conocimiento (Graphify)
Si el proyecto cuenta con Graphify (directorio `graphify-out/` o archivo `graph.json` presente en el repositorio):
- Es obligatorio ejecutar `graphify update .` antes de dar por completado el Pre-flight Check. Esto asegura la coherencia del grafo y que `graphify-out/GRAPH_REPORT.md` refleje las modificaciones recientes.
- Si el comando de actualización falla, el Pre-flight Check se marcará como `blocked` o `fail`.

### Deuda Técnica
- Si el cambio de código requiere introducir bypasses de arquitectura, atajos temporales o reducción temporal de cobertura de tests, el agente executor debe registrar formalmente la entrada de deuda técnica en `projects/<project-name>/docs/specs/technical_debt.md` (o el archivo equivalente local).
- El Pre-flight Check fallará si se detectan parches técnicos que no estén debidamente documentados y aprobados en el registro de deuda técnica.



## 4. Protocolo de Fallo
Si un pre-flight falla:
1. Analizar el log relevante.
2. Corregir la causa raíz si está dentro del alcance de la tarea.
3. Re-ejecutar la verificación fallida y cualquier verificación afectada por la corrección.
4. **Límite de Auto-Sanación (Self-Healing Loop Guard):** El agente tiene un límite máximo de 3 iteraciones autónomas de corrección y verificación de pre-flight. Si en el tercer intento la falla persiste, el agente debe detener el proceso, marcar la tarea como `blocked` y elevar un reporte detallado con las trazas y la hipótesis del fallo para el desarrollador humano.
5. Si la falla requiere decisión de Planner/User o está fuera del alcance, marcar `blocked` con evidencia.
6. No marcar tarea como `done` ni pedir commit/PR mientras existan verificaciones obligatorias en `fail` o `blocked`.


## 5. Excepciones Permitidas
Puede omitirse verificación completa solo cuando:
- El cambio es exclusivamente documentación estática y no modifica specs ejecutables, OpenAPI, migraciones, config, código, tests, scripts ni workflows.
- El entorno no permite ejecutar el comando por falta de dependencias, red, Docker, permisos o servicios externos.

En ambos casos el resultado debe registrarse como `skipped-with-reason`, no como `pass`.

## 6. Reglas No Negociables
- No inventar resultados de tests/build.
- No reportar `pass` si el comando no se ejecutó.
- No ocultar fallas intermitentes; reportarlas como riesgo residual o `blocked`.
- No usar comandos destructivos para "limpiar" el repo sin autorización explícita.
- No aprobar cambios en domain, application, infrastructure, seguridad, DB, API, frontend runtime o workflows sin verificación relevante.
- Si los tests existentes fallan por causas previas no relacionadas, reportar evidencia y separar `pre-existing failure` de regresión introducida.
