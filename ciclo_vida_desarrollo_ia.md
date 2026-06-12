# Ciclo de Vida del Desarrollo de IA (SDLC-IA)

Este documento establece el estándar para el Ciclo de Vida de Desarrollo (Software Development Life Cycle) gobernado por agentes de IA, clasificando a los agentes por roles, detallando las transiciones de estado, los gates de validación humana (Human-in-the-Loop) y las políticas de Git-Ops a nivel local y global.

---

## 1. Clasificación de Agentes

Para garantizar una correcta división de responsabilidades y flujos de comunicación eficientes, los agentes de OpenCode se clasifican en tres categorías:

### A. Obreros (Workers)
Son los agentes que implementan cambios en el código, documentación técnica u operaciones de infraestructura:
*   [executor](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/executor.md): Escribe código de producción y tests unitarios locales.
*   [architect-executor](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/architect-executor.md): Modifica lógica compleja, estructuras de clases y patrones de arquitectura hexagonal locales.
*   [devops-architect](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/devops-architect.md): Modifica Docker, configuraciones de red, CI/CD y despliegue local.
*   [refactor](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/refactor.md): Realiza refactorizaciones de código legacy sin cambiar el comportamiento externo.
*   [documentation](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/documentation.md): Consolida documentación final, especificaciones e historial de cambios.
*   [spec-remediator](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/spec-remediator.md): Corrige drifts mecánicos y hallazgos menores reportados por los validadores en la especificación.
*   [functional-tester-agent](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/functional-tester-agent.md): Diseña, ejecuta y corrige fallos en las pruebas funcionales de interfaz (E2E/UI).

### B. Consultores (Consultants)
Agentes especializados que asesoran, diseñan arquitectura y descomponen planes de trabajo:
*   [requirements-analyst](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/requirements-analyst.md): Levanta requerimientos funcionales y genera el Brief inicial.
*   [planner](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/planner.md): Diseña la especificación del incremento (Delta Spec) y los contratos OpenAPI.
*   [enterprise-architect](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/enterprise-architect.md): Define el System Landscape global, límites del Solution Workspace y boundaries de microservicios.
*   [solution-architect](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/solution-architect.md): Provee los mejores patrones de diseño (GoF) y estructura hexagonal local.
*   [test-architect](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/test-architect.md): Diseña la estrategia de testing y genera casos de prueba unitarios y de integración.
*   [functional-test-planner](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/functional-test-planner.md): Analiza las specs y diseña el plan detallado de pruebas funcionales de usuario.
*   [task-decomposer](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/task-decomposer.md): Divide especificaciones validadas y aprobadas en un Task Board de tareas atómicas y secuenciales.
*   [context-curator](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/context-curator.md): Prepara contexto de alta señal y maneja el ciclo de vida del SDD context.

### C. Validadores (Validators)
Agentes con permiso de solo lectura de código que auditan la calidad, seguridad y consistencia de los artefactos:
*   [spec-validator](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/spec-validator.md): Audita las especificaciones locales de proyecto buscando ambigüedades.
*   [enterprise-spec-validator](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/enterprise-spec-validator.md): Audita la alineación entre las interfaces de los proyectos y la Master Spec global del Workspace.
*   [reviewer](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/reviewer.md): Revisa el código implementado buscando bugs y architecture drift.
*   [security-reviewer](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/security-reviewer.md): Audita políticas de seguridad (CORS, JWT, Keycloak, boundaries).
*   [final-validation](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/final-validation.md): Valida el incremento completado, verificando cobertura de tests (>85%) y criterios de aceptación.

### D. Asistentes Personales (Personal Assistants)
Agentes externos al ciclo de desarrollo de software (SDLC) que operan como tu interfaz personal, pero con capacidad de interactuar y delegar trabajo a los agentes del SDLC.
*   [hyprmind-orchestrator](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/hyprmind-orchestrator.md): (V.I.E.R.N.E.S.) Orquestador conversacional principal de tu sistema y manejador del workspace.
*   [hyprmind-deep-thinker](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/hyprmind-deep-thinker.md): Filósofo y motor de razonamiento denso para discusiones complejas o diseño abstracto.
*   [hyprmind-vision-analyst](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/hyprmind-vision-analyst.md): El "Ojo Biónico" que procesa y explica tus capturas de pantalla o interfaces visuales.

---

## 2. Flujo Completo del Ciclo de Vida de Desarrollo

El flujo varía si trabajamos en un **proyecto Greenfield** (nuevo) o **Brownfield** (existente), y si existe un **Workspace** (multi-proyecto bajo la carpeta `projects/`) o es **Standalone**.

### A. Flujo de Inicialización (Sistema Nuevo o Sin Specs/Grafos)
1.  **Si el Workspace no existe (Standalone):**
    *   `planner` inicializa la Master Spec en `docs/specs/master_spec.md` y crea los contratos `openapi.yaml`.
    *   Se corre `graphify install --project` y `graphify update .` en el repositorio para generar por primera vez la carpeta `graphify-out/` con `GRAPH_REPORT.md`.
2.  **Si el Workspace existe:**
    *   `enterprise-architect` inicializa la Master Spec global de la solución en la raíz `docs/specs/master_spec.md` y crea `docs/specs/workspace_changes.md`.
    *   Se corre `graphify install` y `graphify update .` en la raíz de la solución para indexar la estructura multi-proyecto global.

---

### B. Flujo de Desarrollo Incremental (Paso a Paso con Validación Humana)

El desarrollo de cualquier incremento (nueva característica o refactorización) sigue un ciclo estrictamente secuencial y bloqueado por Gates de Aprobación Humana:

```
[Fase 1: Requerimientos] 
      │ (Brief)
      ▼
[Fase 2: Planificación (Planner)] 
      │ (Delta Spec + OpenAPI)
      ▼
[Fase 3: Validación IA (Spec Validator)]
      │ (verdict: ready)
      ▼
┌───────────────────────────────────────┐
│ GATED: Aprobación Humana de Plan      │ <── REQUIERE: ## Human Plan Approval: approved_by_user
└───────────────────────────────────────┘
      │ (Desbloqueado)
      ▼
[Fase 4: Descomposición (Task Decomposer)]
      │ (Task Board: todo)
      ▼
[Fase 5: Ejecución (Executor)] 
      │ (Código + Tests + Pre-flight)
      ▼
[Fase 6: Validación de Calidad (Reviewer & Final Validation)]
      │ (Cobertura >85% + No Drift)
      ▼
┌───────────────────────────────────────┐
│ GATED: Aprobación Humana de QA        │ <── REQUIERE: ## Human QA Approval: approved_by_user
└───────────────────────────────────────┘
      │ (Desbloqueado)
      ▼
[Fase 7: Git-Ops (Merge & Despliegue)] ──> feature/* -> develop -> QA -> master (Prod)
```

#### Fase 1: Levantamiento de Requerimientos
*   **Agentes:** `requirements-analyst` (Consultor) interactúa con el Usuario.
*   **Entregable:** `docs/specs/requirements/<increment-name>-requirements-brief.md`.
*   **Estado:** `requirements-discovery`.
*   **Git-Ops:** Se crea localmente la rama `feature/<increment-name>` a partir de `develop`.

#### Fase 2: Planificación y Diseño de Contratos
*   **Agentes:** `planner` (Consultor) consulta a `solution-architect` (patrones GoF) y `enterprise-architect` (boundaries).
*   **Entregable:** Delta Spec en `docs/specs/increments/<increment-name>.md` y actualización de `openapi.yaml`.
*   **Estado:** `planning`.

#### Fase 3: Validación IA de Especificaciones
*   **Agentes:** `spec-validator` (Validador local) y `enterprise-spec-validator` (Validador de Workspace global).
*   **Entregable:** Reporte de validación técnica con veredicto: `ready` o `revision-needed`.
*   **Estado:** `validator-review` / `validated-not-executed`.

#### Fase 4: Gate de Validación Humana de Plan (Human-in-the-Loop 1)
*   **Estado de Espera:** `awaiting-human-plan-approval`.
*   **Regla:** Una vez que los validadores de IA otorgan el veredicto `ready`, los agentes se detienen.
*   **Acción del Usuario:** El desarrollador humano revisa el plan, los contratos de API propuestos y la arquitectura. Para continuar, escribe explícitamente en el Shared Context:
    `## Human Plan Approval: approved_by_user`
*   **Bloqueo:** Si este encabezado exacto no existe en el Shared Context, el `task-decomposer` tiene prohibido iniciar y se bloqueará inmediatamente como `Blocked: Awaiting Human Plan Approval`.

#### Fase 5: Descomposición de Tareas
*   **Agentes:** `task-decomposer` (Consultor).
*   **Entregable:** Tablero de tareas `docs/specs/tasks/<increment-name>-task-board.md` en estado `todo`.
*   **Estado:** `decomposition-completed` -> `todo`.

#### Fase 6: Implementación, Testing y Verificación Pre-flight
*   **Agentes:** `executor` / `architect-executor` (Obreros), `test-architect` (Consultor).
*   **Acciones:** Implementar código, tests unitarios e integración. Escribir registros de deuda técnica local en `technical_debt.md` si aplica.
*   **Pre-flight check obligatorio:** Compilar, pasar tests locales y ejecutar `graphify update .`.
*   **Estado:** `in_progress` -> `done`.

#### Fase 7: Validación de Calidad y Cobertura (Final Validation)
*   **Agentes:** `reviewer` (Validador), `security-reviewer` (Validador) y `final-validation` (Validador).
*   **Acciones:** Auditar código contra bugs, seguridad y verificar cobertura de pruebas >85% por archivo testable.
*   **Estado:** `validation-review` -> `quality-approved`.

#### Fase 8: Gate de Validación y Cierre Humano (Human-in-the-Loop 2)
*   **Estado de Espera:** `awaiting-human-qa-approval`.
*   **Acción del Usuario:** El desarrollador humano realiza pruebas manuales o ejecuta los tests de interfaz del `functional-tester-agent`. Si todo es correcto, escribe en el Shared Context:
    `## Human QA Approval: approved_by_user`
*   **Bloqueo:** Los agentes no pueden realizar fusiones o promover ramas de Git si falta esta aprobación humana.

---

## 3. Estrategia de Git-Ops (Políticas de Ramas y Promociones)

El flujo de envío de cambios de código sigue las siguientes políticas estrictas:

1.  **Desarrollo Local (`feature/*`):**
    *   Todo el desarrollo se realiza en la rama `feature/<increment-name>`.
    *   Se realizan commits locales semánticos (ej: `feat(user): add auth endpoint`) únicamente después de que el `pre-flight-check` haya pasado con éxito.
2.  **Integración a Desarrollo (`develop`):**
    *   Una vez que el humano otorga `## Human QA Approval: approved_by_user`, el agente de `git-ops` realiza el merge local de `feature/<increment-name>` a `develop`.
    *   Se ejecuta `git push origin develop` para activar las pruebas de integración en el servidor de CI/CD.
3.  **Promoción a Pruebas (`QA`):**
    *   Tras verificar que el pipeline en `develop` es exitoso, se genera un Pull Request de `develop` hacia la rama `qa` (o se despliega al entorno de QA).
    *   El agente `functional-tester-agent` ejecuta las pruebas funcionales de regresión en este entorno.
4.  **Promoción a Producción (`master` / `main`):**
    *   Solo tras la aprobación del QA por parte del humano, se realiza el Pull Request e integración a la rama `master`.
    *   Se etiqueta la versión en Git y se archiva el shared context de incremento pasándolo a histórico.

---

## 4. Gobernanza de Estados (AI-Owned State Integrity)

Para evitar desvíos o elusión de los gates obligatorios, se establece la siguiente regla de inmutabilidad:
*   **Propiedad de la IA:** Los bloques de estado (`## Current status`, `## Spec Validator Approval`, veredictos y resúmenes de auditorías) pertenecen exclusivamente a los agentes de IA. Ningún humano debe editar o manipular manualmente estos campos.
*   **Única Firma Humana Permitida:** El programador humano solo debe editar e insertar las firmas exactas de aprobación:
    *   `## Human Plan Approval: approved_by_user`
    *   `## Human QA Approval: approved_by_user`
*   **Detección de Corrupción:** Los agentes validadores (`spec-validator`, `enterprise-spec-validator` y `final-validation`) auditarán el historial y coherencia del Shared Context. Si detectan que un humano modificó a mano un estado para saltarse un gate (por ejemplo, escribir `Current status: validated-not-executed` sin la aprobación del validador de IA), bloquearán inmediatamente la tarea marcando el incremento como `corrupted-state` y se detendrán con `Blocked: State corruption detected`.

---

## 5. Protección de Ramas local mediante Git Hooks

Para blindar el ciclo de desarrollo y asegurar que ni el desarrollador humano ni los agentes robot puedan empujar código incompleto o sin validar, se instala el hook **`pre-push`** local (`.git/hooks/pre-push`):

*   **Funcionamiento:**
    *   Cada vez que se ejecuta un `git push` local hacia ramas estables (`develop`, `qa`, `master` o `main`), el hook intercepta la operación.
    *   Busca el Shared Context en `docs/specs/.working/<increment-name>-sdd-context.md` de la rama feature activa.
    *   Verifica que contenga el estado adecuado (`quality-approved` o superior) y la firma exacta `## Human QA Approval: approved_by_user`.
    *   Si no se cumple la condición, el push es rechazado inmediatamente con código de salida 1, mostrando un error detallado del gate pendiente.
*   **Instalación:**
    *   La plantilla del hook se encuentra en [pre-push-hook-template.sh](file:///home/cristiansrc/Documentos/config-ai/pre-push-hook-template.sh) y debe instalarse en cada repositorio al crearlo o sincronizarlo.

