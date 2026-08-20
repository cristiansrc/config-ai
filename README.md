# AI Configuration Ecosystem (config-ai)

Este repositorio centraliza la inteligencia, estándares y configuraciones de los agentes de IA para un entorno de desarrollo senior basado en Arquitectura Hexagonal y SDD Incremental.

---

## 📁 Estructura del Proyecto

El ecosistema está organizado para garantizar limpieza, trazabilidad y seguridad:

*   **`active/`**: Configuraciones en uso real por los agentes.
    *   `opencode/`: Agentes y Skills activos para OpenCode.
    *   `gemini/`: Agentes y Skills activos para Gemini CLI.
*   **`logs/`**: Historial operativo y técnico.
    *   `bugs/`: Reportes de errores generados por `spec-remediator` o fallos de validación.
    *   `deuda-tecnica-n8n.md`: Seguimiento de mejoras pendientes.
*   **`archive/`**: Almacén histórico y seguridad.
    *   `snapshots/`: Backups comprimidos (`.tar.gz`) (Últimos 25 snapshots).
    *   `agents/` / `skills/`: Versiones previas de componentes específicos.

---

## 🤖 Definición de Agentes y Responsabilidades

| Agente                        | Responsabilidad Principal                                                             | Modelo                            |
|-------------------------------|---------------------------------------------------------------------------------------|-----------------------------------|
| **enterprise-architect**      | Visión macro, microservicios, System Landscape y Workspace.                           | opencode-go/gpt-5.6-luna                     |
| **reviewer**                  | Revisión de código y lógica.                                                          | opencode-go/muse-spark-1.2-contributor     |
| **requirements-analyst**      | Levanta requerimientos funcionales (`requirements-brief.md`).                         | opencode-go/muse-spark-1.2-contributor     |
| **planner**                   | Arquitectura, diseño técnico y contratos OpenAPI (SDD).                               | opencode-go/minimax-m3                     |
| **spec-validator**            | Validación estricta de consistencia local y veredictos de 'ready'.                    | opencode-go/muse-spark-1.2-contributor     |
| **enterprise-spec-validator** | Validación macro de Workspace, contratos inter-servicios y deuda global.              | opencode-go/muse-spark-1.2-contributor     |
| **api-governance-agent**      | Audita contratos OpenAPI buscando Breaking Changes y compatibilidad semver.            | opencode-go/minimax-m3                     |
| **bug-diagnostician**         | Análisis de causa raíz (RCA) e inspección de logs y stack traces antes de arreglos.   | opencode-go/deepseek-v4-pro                |
| **database-architect**        | Diseña esquemas DB, migraciones Flyway/Liquibase e índices sin inactividad.           | opencode-go/deepseek-v4-pro                |
| **spec-remediator**           | Corrección iterativa de hallazgos mecánicos o de contrato.                            | opencode-go/muse-spark-1.2-contributor     |
| **task-decomposer**           | Atomización de tareas para el ejecutor.                                               | opencode-go/minimax-m3                     |
| **executor**                  | Implementación técnica cuando EXISTE spec SDD validada (Temp 0.15).                    | opencode-go/mimo-v2.5                     |
| **architect-executor**        | Lógica compleja y arquitectura local (Go) cuando NO existe spec SDD.                  | opencode-go/deepseek-v4-pro                |
| **final-validation**          | Garantía de calidad final y cumplimiento de cobertura mínima.                         | opencode-go/muse-spark-1.2-contributor     |
| **solution-architect**        | Selección de patrones de diseño GoF y estructuras locales.                            | opencode-go/muse-spark-1.2-contributor     |
| **security-reviewer**         | Auditoría de seguridad y estándares OWASP.                                            | opencode-go/muse-spark-1.2-contributor     |
| **test-architect**            | Diseño de estrategias de prueba unitarias e integración.                              | opencode-go/mimo-v2.5                     |
| **context-curator**           | Filtra y prepara el contexto de alta señal (Temp 0.10) para evitar ruido.             | opencode-go/muse-spark-1.2-contributor     |
| **devops-architect**          | Especialista en Infraestructura como Código y CI/CD.                                  | opencode-go/mimo-v2.5                     |
| **documentation**             | Gestiona el ciclo de vida de la documentación del proyecto.                           | opencode-go/muse-spark-1.2-contributor     |
| **refactor**                  | Refactoriza código existente siguiendo patrones limpios.                              | opencode-go/deepseek-v4-pro                |
| **functional-tester-agent**   | Diseña plan, ejecuta y valida pruebas funcionales y UI/E2E en frontends.              | opencode-go/hy3                            |
| **git-executor**              | Centraliza todas las interacciones del repositorio con Git (ramas, commits, pushes).   | opencode-go/mimo-v2.5                      |
| **master-orchestrator**       | Agente Maestro / Orquestador Contextual. Mantiene el contexto y delega tareas.        | opencode-go/gpt-5.6-luna                   |

---

## 🗣️ Asistentes Personales (HyprMind)

Agentes que operan fuera del SDLC actuando como asistentes personales con capacidad de delegación.

| Agente                        | Responsabilidad Principal                                                             | Modelo                            |
|-------------------------------|---------------------------------------------------------------------------------------|-----------------------------------|
| **hyprmind-orchestrator**     | Interfaz principal (V.I.E.R.N.E.S.) para interacción por voz y delegación de tareas.  | opencode-go/gpt-5.6-luna          |
| **hyprmind-vision-analyst**   | Ojo Biónico para análisis de imágenes, UI y capturas de pantalla de código.           | opencode-go/gpt-5.6-luna          |
| **hyprmind-deep-thinker**     | Analista profundo para problemas arquitectónicos o lógicos muy complejos.             | opencode-go/gpt-5.6-luna          |

---

## 📚 Ecosistema de Skills (56 Skills)

Las skills están organizadas por dominios técnicos y arquitectónicos:

### 🏗️ Arquitectura y Metodología
*   **hexagonal-architecture**: Implementación de Puertos y Adaptadores con directorios explícitos por tecnología (Java, Python, Go, TS).
*   **spec-driven-development**: Ciclo de vida Master Spec e Incrementos con gates humanos.
*   **openapi-first**: Diseño de APIs basado en contratos.
*   **requirements-gathering**: Protocolo de levantamiento de necesidades.
*   **api-governance-linter**: Auditoría de Breaking Changes en contratos OpenAPI 3.0/3.1 y versión semántica (SemVer).

### 💻 Backend Stack
*   **springboot-stack / java-stack / kotlin-stack**: Estándares para el ecosistema JVM.
*   **golang-stack**: Estándares de calidad y estructura de backend en Go/Golang.
*   **springboot-java-rest-error-response-standards / springboot-kotlin-rest-error-response-standards**: Contratos de errores REST para Spring Boot.
*   **fastapi-stack / python-stack / fastapi-rest-error-response-standards**: Patrones avanzados para Python y contratos de errores REST.
*   **nodejs-stack**: Arquitectura limpia para entornos Node.js con TypeScript.
*   **openapi-standard / restful-standard**: Convenciones globales de contrato y semántica REST.
*   **jpa-stack / repository-dto-patterns**: Gestión de persistencia y transferencia de datos.

### 🗄️ Bases de Datos y Migraciones
*   **zero-downtime-migrations**: Evolución de esquemas relacionales sin inactividad (Patrón Expand/Contract y `CREATE INDEX CONCURRENTLY`).
*   **flyway-migrations**: Gestión de esquemas multi-motor y scripts de migración.
*   **postgresql / mysql / oracle / sqlserver-standard**: Configuraciones específicas por motor.

### 🎨 Frontend
*   **react-stack / angular-stack**: Convenciones de FSD, React 19, Angular Signals y Standalone.
*   **frontend-architecture**: Arquitectura limpia para SPAs.
*   **minimalist-ui**: Diseño de interfaces minimalistas y limpias al estilo editorial (Warm monochrome, bento grids).

### 🔐 Seguridad, Calidad y Calibración
*   **security-standards / keycloak-standard**: JWT, OAuth2, RBAC, Gitleaks Secret Shield y protección de identidad.
*   **code-quality-and-sonarqube**: SonarQube local, SonarScanner, Linters (Ruff, SpotBugs, golangci-lint) y bucle `./verify-code.sh`.
*   **testing-strategy**: Metodología TDD (Red-Green-Refactor), ArchUnit (tests de arquitectura), Pruebas de Concurrencia y Testcontainers.
*   **performance-testing-k6**: Pruebas de carga, estrés y latencia con k6 (SLA p95 < 200ms).
*   **root-cause-analysis**: Protocolo RCA y triage no destructivo de logs/stack traces.
*   **pre-flight-check**: Validación técnica obligatoria antes de commits con Self-Healing Guard.
*   **bug-fixing-workflow**: Protocolo riguroso de reproducción y fix.

### 🔄 Orquestación, DevOps & EvalOps
*   **git-ops**: Automatización de ramas, commits semánticos, Gitleaks y PRs validados por humanos.
*   **eval-ops-agent-benchmarks**: Benchmarking automatizado y pruebas de regresión para agentes de IA.
*   **graphify**: Optimización de contexto mediante grafos de conocimiento estructurados (v0.9.39).
*   **workspace-coordination**: Sincronización global-local y control de deuda técnica.
*   **model-tier-routing**: Escalamiento de modelos por niveles (Tiers 1 al 6).
*   **context-pinning / context-curation**: Gestión de contexto y protección de Master Spec.
*   **n8n-stack**: Estrategia de automatización de workflows.

### 🧠 Ecosistema HyprMind
*   **hyprmind-delegation-protocol**: Protocolo estructurado de delegación hacia agentes SDD.
*   **hyprmind-memory-manager**: Gestión de memoria conversacional con caducidad de 2 horas.
*   **hyprmind-workspace-manager**: Protocolos para apertura automática de IDEs (IntelliJ, VS Code, etc) y visualización de documentos.

---

## 🛠️ Reglas Operativas Críticas

1.  **Aislamiento de Proyecto**: Los agentes tienen PROHIBIDO escribir o buscar fuera del repositorio activo (`<active-repo>`).
2.  **Placeholder Guard**: El marcador `<increment-name>` debe resolverse dinámicamente o preguntar al usuario; nunca usarse literal.
3.  **Cobertura Mínima**: 85% obligatorio en archivos testables.
4.  **Gates de Validación Humana**: Bloqueo estricto del desarrollo en los estados `awaiting-human-plan-approval` (después de validación de spec) y `awaiting-human-qa-approval` (después de validación final de código). Requiere firmas explícitas en el Shared Context.
5.  **Inmutabilidad de Estados**: Los humanos tienen prohibido alterar bloques de estado de IA a mano. Toda manipulación manual suspende el flujo por `corrupted-state`.
7.  **Flujo SDD Actualizado**: `Requirements Analyst` ➔ `Planner` ➔ `Spec Validator` ➔ `Enterprise Spec Validator` (si aplica) ➔ **Plan Aprobado por Humano Gate** ➔ `Task Decomposer` ➔ `Executor` ➔ `Final Validation` ➔ **QA Aprobado por Humano Gate** ➔ `Git-Ops`.
8.  **Aislamiento Operativo de Git**: Queda ESTRICTAMENTE PROHIBIDO para todos los agentes de desarrollo, pruebas o documentación ejecutar cualquier comando Git (`git add`, `git commit`, `git push`, `git checkout`, etc.) en la terminal. Toda operación relacionada con Git debe delegarse de forma exclusiva al agente `git-executor`.

---

## 🛠️ Herramientas y Utilidades

### 🧪 Test de Latencia y Disponibilidad de Modelos
Se incluye el script `test-latency.py` en la raíz del repositorio para verificar de forma rápida la disponibilidad y latencia de respuesta de los modelos activos de OpenCode antes de iniciar sesiones largas de desarrollo:

*   **Uso:**
    ```bash
    python3 ./test-latency.py
    ```
*   **Modelos Probados:**
    *   `opencode-go/gpt-5.6-luna` (Luna del Plan Go / Orquestación macro, arquitectura)
    *   `opencode-go/muse-spark-1.2-contributor` (Muse Spark / Validación, remediación, QA, patrones, curación, docs, review, seguridad)
    *   `opencode-go/hy3` (hy3 del Plan Go / UI-E2E)
    *   `opencode-go/deepseek-v4-pro` (DeepSeek V4 Pro / Código pesado + architect-executor, servidores China)
    *   `opencode-go/minimax-m3` (MiniMax M3 / Planning, gobernanza, descomposición)
    *   `opencode-go/mimo-v2.5` (MiMo V2.5 / Ejecución de volumen + Git)

---
*Última actualización de estructura y roles: 2026-08-20 (migración a muse-spark-1.2-contributor para validación, QA, patrones, curación, docs y review; architect-executor → deepseek-v4-pro)*
