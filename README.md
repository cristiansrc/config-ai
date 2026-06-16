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
| **enterprise-architect**      | Visión macro, microservicios, System Landscape y Workspace.                           | opencode-go/qwen3.7-plus        |
| **reviewer**                  | Revisión de código y lógica.                                                          | opencode-go/qwen3.7-plus        |
| **requirements-analyst**      | Levanta requerimientos funcionales (`requirements-brief.md`).                         | opencode-go/qwen3.7-plus             |
| **planner**                   | Arquitectura, diseño técnico y contratos OpenAPI (SDD).                               | opencode-go/qwen3.7-plus          |
| **spec-validator**            | Validación estricta de consistencia local y veredictos de 'ready'.                    | opencode-go/qwen3.7-plus          |
| **enterprise-spec-validator** | Validación macro de Workspace, contratos inter-servicios y deuda global.              | opencode-go/qwen3.7-plus          |
| **spec-remediator**           | Corrección iterativa de hallazgos mecánicos o de contrato.                            | opencode-go/deepseek-v4-flash   |
| **task-decomposer**           | Atomización de tareas para el ejecutor.                                               | opencode-go/deepseek-v4-pro       |
| **executor**                  | Implementación técnica y verificación pre-vuelo.                                      | opencode-go/deepseek-v4-flash   |
| **final-validation**          | Garantía de calidad final y cumplimiento de cobertura mínima.                         | opencode-go/qwen3.7-plus        |
| **solution-architect**        | Selección de patrones de diseño GoF y estructuras locales.                            | opencode-go/qwen3.7-plus        |
| **security-reviewer**         | Auditoría de seguridad y estándares OWASP.                                            | opencode-go/qwen3.7-plus        |
| **test-architect**            | Diseño de estrategias de prueba y automatización.                                     | opencode-go/deepseek-v4-flash   |
| **context-curator**           | Filtra y prepara el contexto de alta señal para evitar ruido a los Obreros.           | opencode-go/qwen3.7-plus             |
| **architect-executor**        | Implementa tareas de arquitectura local y lógica compleja.                             | opencode-go/deepseek-v4-flash   |
| **devops-architect**          | Especialista en Infraestructura como Código y CI/CD.                                  | opencode-go/deepseek-v4-flash   |
| **documentation**             | Gestiona el ciclo de vida de la documentación del proyecto.                           | opencode-go/deepseek-v4-flash   |
| **refactor**                  | Refactoriza código existente siguiendo patrones limpios.                              | opencode-go/deepseek-v4-pro       |
| **functional-test-planner**   | Diseña planes de pruebas funcionales y flujos de usuario estructurados.               | opencode-go/deepseek-v4-flash   |
| **functional-tester-agent**   | Diseña, ejecuta y valida pruebas funcionales y UI/E2E en frontends.                   | opencode-go/deepseek-v4-flash   |
| **git-executor**              | Centraliza todas las interacciones del repositorio con Git (ramas, commits, pushes).   | opencode-go/deepseek-v4-flash   |
| **master-orchestrator**       | Agente Maestro / Orquestador Contextual. Mantiene el contexto y delega tareas.        | opencode-go/deepseek-v4-flash   |

---

## 🗣️ Asistentes Personales (HyprMind)

Agentes que operan fuera del SDLC actuando como asistentes personales con capacidad de delegación.

| Agente                        | Responsabilidad Principal                                                             | Modelo                            |
|-------------------------------|---------------------------------------------------------------------------------------|-----------------------------------|
| **hyprmind-orchestrator**     | Interfaz principal (V.I.E.R.N.E.S.) para interacción por voz y delegación de tareas.  | opencode-go/qwen3.7-plus             |
| **hyprmind-vision-analyst**   | Ojo Biónico para análisis de imágenes, UI y capturas de pantalla de código.           | opencode-go/deepseek-v4-flash      |
| **hyprmind-deep-thinker**     | Analista profundo para problemas arquitectónicos o lógicos muy complejos.             | opencode-go/qwen3.7-plus             |

---

## 📚 Ecosistema de Skills (50 Skills)

Las skills están organizadas por dominios técnicos y arquitectónicos:

### 🏗️ Arquitectura y Metodología
*   **hexagonal-architecture**: Implementación de Puertos y Adaptadores.
*   **spec-driven-development**: Ciclo de vida Master Spec e Incrementos con gates humanos.
*   **openapi-first**: Diseño de APIs basado en contratos.
*   **requirements-gathering**: Protocolo de levantamiento de necesidades.

### 💻 Backend Stack
*   **springboot-stack / java-stack / kotlin-stack**: Estándares para el ecosistema JVM.
*   **golang-stack**: Estándares de calidad y estructura de backend en Go/Golang.
*   **springboot-java-rest-error-response-standards / springboot-kotlin-rest-error-response-standards**: Contratos de errores REST para Spring Boot.
*   **fastapi-stack / python-stack / fastapi-rest-error-response-standards**: Patrones avanzados para Python y contratos de errores REST.
*   **nodejs-stack**: Arquitectura limpia para entornos Node.js con TypeScript.
*   **openapi-standard / restful-standard**: Convenciones globales de contrato y semántica REST.
*   **jpa-stack / repository-dto-patterns**: Gestión de persistencia y transferencia de datos.

### 🗄️ Bases de Datos y Migraciones
*   **flyway-migrations**: Gestión de esquemas multi-motor.
*   **postgresql / mysql / oracle / sqlserver-standard**: Configuraciones específicas por motor.

### 🎨 Frontend
*   **react-stack / angular-stack**: Convenciones de FSD, React 19, Angular Signals y Standalone.
*   **frontend-architecture**: Arquitectura limpia para SPAs.
*   **minimalist-ui**: Diseño de interfaces minimalistas y limpias al estilo editorial (Warm monochrome, bento grids).

### 🔐 Seguridad y Calidad
*   **security-standards / keycloak-standard**: JWT, OAuth2, RBAC y protección de identidad.
*   **testing-strategy**: Estrategia Unit, Integration (Testcontainers) y E2E.
*   **pre-flight-check**: Validación técnica obligatoria antes de commits con Self-Healing Guard.
*   **bug-fixing-workflow**: Protocolo riguroso de reproducción y fix.

### 🔄 Orquestación y DevOps
*   **git-ops**: Automatización de ramas, commits semánticos y PRs validados por humanos.
*   **graphify**: Optimización de contexto mediante grafos de conocimiento estructurados.
*   **workspace-coordination**: Sincronización global-local y control de deuda técnica.
*   **model-tier-routing**: Escalamiento de modelos según complejidad.
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
    *   `opencode-go/qwen3.7-plus` (Qwen 3.6 Plus Libre / Gratuito)
    *   `opencode-go/qwen3.6-plus` (Qwen 3.6 Plus del Plan Go / Respaldo)
    *   `google/gemini-3.1-pro-preview` (Gemini Pro Comercial / Google API)
    *   `opencode-go/deepseek-v4-flash` (DeepSeek V4 Flash Libre / Gratuito)

---
*Última actualización de estructura y roles: 2026-06-15*

