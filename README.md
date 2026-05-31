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

| Agente | Responsabilidad Principal | Modelo |
|---|---|---|
| **requirements-analyst** | Levanta requerimientos funcionales (`requirements-brief.md`). | qwen3.6-plus |
| **planner** | Arquitectura, diseño técnico y contratos OpenAPI (SDD). | qwen3.6-plus |
| **spec-validator** | Validación estricta de consistencia local y veredictos de 'ready'. | deepseek-v4-pro |
| **enterprise-spec-validator** | Validación macro de Workspace, contratos inter-servicios y deuda global. | deepseek-v4-pro |
| **spec-remediator** | Corrección iterativa de hallazgos mecánicos o de contrato. | deepseek-v4-flash |
| **task-decomposer** | Atomización de tareas para el ejecutor. | qwen3.5-plus |
| **executor** | Implementación técnica y verificación pre-vuelo. | deepseek-v4-flash |
| **final-validation** | Garantía de calidad final y cumplimiento de cobertura mínima. | qwen3.6-plus |
| **solution-architect** | Selección de patrones de diseño GoF y estructuras locales. | qwen3.6-plus |
| **enterprise-architect** | Visión macro, microservicios, System Landscape y Workspace. | qwen3.6-plus |
| **reviewer** | Revisión de código y lógica. | qwen3.5-plus |
| **security-reviewer** | Auditoría de seguridad y estándares OWASP. | deepseek-v4-pro |
| **test-architect** | Diseño de estrategias de prueba y automatización. | qwen3.5-plus |

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

---

## 🛠️ Reglas Operativas Críticas

1.  **Aislamiento de Proyecto**: Los agentes tienen PROHIBIDO escribir o buscar fuera del repositorio activo (`<active-repo>`).
2.  **Placeholder Guard**: El marcador `<increment-name>` debe resolverse dinámicamente o preguntar al usuario; nunca usarse literal.
3.  **Cobertura Mínima**: 85% obligatorio en archivos testables.
4.  **Gates de Validación Humana**: Bloqueo estricto del desarrollo en los estados `awaiting-human-plan-approval` (después de validación de spec) y `awaiting-human-qa-approval` (después de validación final de código). Requiere firmas explícitas en el Shared Context.
5.  **Inmutabilidad de Estados**: Los humanos tienen prohibido alterar bloques de estado de IA a mano. Toda manipulación manual suspende el flujo por `corrupted-state`.
6.  **Protección de Ramas local**: Es obligatorio el uso de Git Hook `pre-push` local en base a los estados del SDLC-IA para evitar push incorrectos a `develop`, `qa` y `master`.
7.  **Flujo SDD Actualizado**: `Requirements Analyst` ➔ `Planner` ➔ `Spec Validator` ➔ `Enterprise Spec Validator` (si aplica) ➔ **Plan Aprobado por Humano Gate** ➔ `Task Decomposer` ➔ `Executor` ➔ `Final Validation` ➔ **QA Aprobado por Humano Gate** ➔ `Git-Ops`.

---
*Última actualización de estructura y roles: 2026-05-31*

