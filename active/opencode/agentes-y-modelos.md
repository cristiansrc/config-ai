# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-08-20 (migracion a muse-spark-1.2-contributor para validacion, QA, patrones, curacion, docs, review y seguridad; architect-executor migrado a deepseek-v4-pro)

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.jsonc`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/Proyectos/config-ai/active/opencode/agents/`
- Backup de skills: `/home/cristiansrc/Documentos/Proyectos/config-ai/active/opencode/skills/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/Proyectos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Idioma obligatorio: Todas las respuestas e interacciones de los agentes con el usuario deben ser en ESPANOL.
- Politica de idioma de agentes: La definicion operativa, responsabilidades, reglas y guias de cada agente deben estar en ESPANOL. Se mantienen en INGLES los nombres de agentes/skills, estados canonicos, headings, rutas, comandos, campos de protocolo y tokens exactos como `ready`, `blocked`, `validated-not-executed`, `## Spec Validator Approval` o `Blocked: ...`.
- Contratos de error por stack: Spring Boot Java usa `springboot-java-rest-error-response-standards`, Spring Boot Kotlin usa `springboot-kotlin-rest-error-response-standards` y FastAPI usa `fastapi-rest-error-response-standards`.
- Convenciones de stack: `nodejs-stack`, `python-stack`, `fastapi-stack`, `springboot-stack`, `java-stack`, `kotlin-stack` y `golang-stack` son la fuente de verdad para reglas tecnicas de cada runtime.
- Estandar de Testing Funcional: `functional-testing-standard` define la estrategia de planeacion, reporte y correccion de pruebas UI/E2E en frontends utilizando Puppeteer MCP o frameworks locales.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.
- Cambio operativo vigente: Spec Remediator debe invocar validaciones solo mediante `spec-validator` con `opencode-go/muse-spark-1.2-contributor`; cualquier validacion ejecutada con otro modelo debe bloquearse como `Blocked: wrong validator model`.
- Estandares de Calidad y Pruebas Avanzadas: `code-quality-and-sonarqube` (SonarScanner, SpotBugs, Ruff, golangci-lint, script ./verify-code.sh), `performance-testing-k6` (k6 load testing, p95 < 200ms), `eval-ops-agent-benchmarks` (benchmarks de regresion de agentes), `zero-downtime-migrations` (Expand/Contract DB), `root-cause-analysis` (RCA protocol), `api-governance-linter` (OpenAPI breaking changes) y `testing-strategy` (TDD Red-Green-Refactor, ArchUnit, Concurrencia).
- Estructura de Solution Workspace (OPCIONAL): La pertenencia a un Solution Workspace esta condicionada a que la carpeta padre del proyecto se llame exactamente `projects/`.
- Gestion de Paquetes JS/TS: Queda ESTRICTAMENTE PROHIBIDO el uso de `npm` para cualquier tarea (Node, React, Angular, etc.). Se debe utilizar exclusivamente `pnpm`.
- Soporte de Contexto mediante Grafos (Graphify): Para optimizar el contexto de los agentes, reducir el consumo de tokens y asegurar la trazabilidad arquitectonica, se utiliza Graphify en los proyectos compatibles.
- Aislamiento Operativo de Git: Queda ESTRICTAMENTE PROHIBIDO para todos los agentes de desarrollo, pruebas o documentacion ejecutar cualquier comando Git. Toda operacion Git debe delegarse exclusivamente al agente `git-executor`.

---

## BLOQUEO DE MODELOS (Agosto 2026)

| Modelo | Razon | Fuente |
|--------|-------|--------|
| `opencode-go/deepseek-v4-flash` | Molestando de nuevo (rollback 2026-08-17). TCP drop, 403, 400. | GitHub #40465, #40485, #41306 |
| `opencode/deepseek-v4-flash-free` | 503 cola llena, bucles infinitos, resp vacias | GitHub #40254, #30443 |
| `opencode-go/qwen3.7-plus` | Inestabilidad 70%. Timeouts Cloudflare 524. **Retirado.** | GitHub #32418, #33721 |
| `opencode-go/qwen3.6-plus` | Modelo legacy. **Retirado.** | - |

---

## Estado de Modelos Go (Agosto 2026)

| Modelo | Req/5h | Costo 1M in/out | SWE-Bench | Notas |
|--------|--------|-----------------|-----------|-------|
| **gpt-5.6-luna** | 2,050 | $0.20/$1.20 | 62.7% | **PRIMARIO**. Orquestacion macro y arquitectura enterprise. Vision multimodal. |
| **muse-spark-1.2-contributor** | N/D | N/D (bajo) | N/D | **Muse Spark**. Validacion, remediacion, QA, patrones GoF, curacion, docs, review seguridad. Ventana 1M, costo mínimo. |
| **hy3** | N/D | N/D | N/D | UI/E2E (functional-tester-agent). |
| **deepseek-v4-pro** | N/D | N/D | N/D | **Coding pesado** (refactor, DB, RCA) + architect-executor. Estable via servidores China (opt-in). |
| **deepseek-v4-flash** | N/D | N/D | N/D | **PROBLEMATICO** (rollback 2026-08-17). Sin agentes asignados. |
| **minimax-m3** | 3,200 | $0.30/$1.20 | 59.0% | Planning, gobernanza OpenAPI, descomposicion. |
| **mimo-v2.5** | 30,100 | $0.14/$0.28 | - | Ultra-ligero. Ejecucion de volumen (executor, tests, devops) + git. |

Perfil LM Studio persistente:
- `lmstudio/qwen/qwen3.6-35b-a3b`: context length `152563`, GPU offload ratio `26/64` capas, K/V cache `Q4_0`. OpenCode declara el mismo limite de contexto.

---

## Tabla de Agentes y Modelos (Actualizada 2026-08-20)

| Agente | Modelo | Proveedor | Editar | Bash | Descripcion |
|--------|--------|-----------|--------|------|-------------|
| api-governance-agent | opencode-go/minimax-m3 | Go | deny | allow | Audita contratos OpenAPI buscando Breaking Changes, backward compatibility y reglas semver. |
| architect-executor | opencode-go/deepseek-v4-pro | Go | allow | allow | Implementa tareas complejas y arquitectura local cuando NO existe especificacion SDD completa. |
| bug-diagnostician | opencode-go/deepseek-v4-pro | Go | deny | allow | Realiza analisis de causa raiz (RCA) e inspeccion de logs/stack traces. |
| context-curator | opencode-go/muse-spark-1.2-contributor | Go | deny | deny | Gestiona la ventana de contexto (Temp 0.10) y reduce ruido. |
| database-architect | opencode-go/deepseek-v4-pro | Go | allow | allow | Disena esquemas DB, migraciones Flyway/Liquibase e indices Zero-Downtime. |
| devops-architect | opencode-go/mimo-v2.5 | Go | allow | allow | Infraestructura como Codigo, Docker, CI/CD. |
| documentation | opencode-go/muse-spark-1.2-contributor | Go | allow | deny | Gestiona documentacion siguiendo `documentation-lifecycle` y `documentation-standards`. |
| enterprise-architect | opencode-go/gpt-5.6-luna | Go | allow | deny | System Landscape, fronteras de microservicios. |
| enterprise-spec-validator | opencode-go/muse-spark-1.2-contributor | Go | allow | deny | Valida coherencia global del Solution Workspace. |
| executor | opencode-go/mimo-v2.5 | Go | allow | allow | Implementa codigo (Temp 0.15) cuando EXISTE spec SDD validada. |
| final-validation | opencode-go/muse-spark-1.2-contributor | Go | deny | allow | Calidad final y cobertura minima siguiendo `testing-strategy` y `pre-flight-check`. |
| functional-tester-agent | opencode-go/hy3 | Go | allow | allow | Pruebas funcionales y UI/E2E con Puppeteer MCP. |
| git-executor | opencode-go/mimo-v2.5 | Go | allow | allow | Operaciones Git exclusivas (ramas, commits, push). **Modelo ligero para ahorrar quota.** |
| master-orchestrator | opencode-go/gpt-5.6-luna | Go | deny | allow | Orquestador Contextual. Mantiene contexto de spec y delega. |
| planner | opencode-go/minimax-m3 | Go | allow | deny | Planifica incrementos SDD y disena contratos OpenAPI. |
| refactor | opencode-go/deepseek-v4-pro | Go | allow | allow | Refactoriza codigo siguiendo `refactor-patterns` y `refactor-hexagonal-bridge`. |
| requirements-analyst | opencode-go/muse-spark-1.2-contributor | Go | allow | deny | Levantamiento de requerimientos funcionales. |
| reviewer | opencode-go/muse-spark-1.2-contributor | Go | deny | allow | Audita codigo buscando drift y bugs. |
| security-reviewer | opencode-go/muse-spark-1.2-contributor | Go | deny | allow | Valida postura de seguridad OWASP, JWT, Keycloak. |
| solution-architect | opencode-go/muse-spark-1.2-contributor | Go | allow | deny | Elige patrones de diseno GoF. |
| spec-remediator | opencode-go/muse-spark-1.2-contributor | Go | allow | deny | Corrige hallazgos de validacion de forma iterativa. |
| spec-validator | opencode-go/muse-spark-1.2-contributor | Go | allow limitado | deny | Valida consistencia de artefactos SDD. **Modelo oficial para spec-remediation.** |
| task-decomposer | opencode-go/minimax-m3 | Go | allow | deny | Descompone especificaciones en tareas atomicas. |
| test-architect | opencode-go/mimo-v2.5 | Go | allow | allow | Disena estrategia de pruebas y genera casos de test. |
| hyprmind-orchestrator | opencode-go/gpt-5.6-luna | Go | allow | allow | V.I.E.R.N.E.S. Orquestador conversacional. |
| hyprmind-vision-analyst | opencode-go/gpt-5.6-luna | Go | deny | deny | Ojo Bionico. Analisis de capturas de pantalla (vision multimodal). |
| hyprmind-deep-thinker | opencode-go/gpt-5.6-luna | Go | deny | deny | Razonamiento denso, filosofia, diseno abstracto. |

---

## Resumen de Cambios (2026-08-20)

### Migracion a Muse Spark (muse-spark-1.2-contributor)

- **Objetivo**: Optimizar costo/beneficio migrando tareas de validacion, QA, patrones y lenguaje natural a Muse Spark (1M contexto, costo casi nulo) y reservar Luna para orquestacion macro.
- **Cambios Muse Spark** (10 agentes): `solution-architect` (luna → muse-spark), `spec-validator` (luna → muse-spark), `enterprise-spec-validator` (luna → muse-spark), `spec-remediator` (luna → muse-spark), `final-validation` (luna → muse-spark), `context-curator` (minimax-m3 → muse-spark), `requirements-analyst` (hy3 → muse-spark), `documentation` (hy3 → muse-spark), `security-reviewer` (minimax-m3 → muse-spark), `reviewer` (hy3 → muse-spark).
- **Cambio DeepSeek V4 Pro** (1 agente): `architect-executor` (luna → deepseek-v4-pro) para codigo complejo sin spec SDD.
- **Mantenidos**: `master-orchestrator` y `enterprise-architect` en `gpt-5.6-luna`; `planner`, `api-governance-agent`, `task-decomposer` en `minimax-m3`; `bug-diagnostician`, `database-architect`, `refactor` en `deepseek-v4-pro`; `executor`, `test-architect`, `devops-architect`, `git-executor` en `mimo-v2.5`; `functional-tester-agent` en `hy3`.
- **Guard actualizado**: `spec-remediator` ahora valida exclusivamente contra `spec-validator` con `muse-spark-1.2-contributor`.

### Cambio previo (2026-08-17): deepseek-v4-flash habilitado y luego ROLLBACK

- **Flash habilitado** (antes ROTO desde Aug 4): asumio codigo pesado + diseno (`refactor`, `database-architect`, `bug-diagnostician`, `planner`, `security-reviewer`) y luego `executor`.
- **Rollback**: flash volvio a molestar (TCP drop, 403, 400). Sus agentes regresaron a sus modelos previos: `refactor`/`database-architect`/`bug-diagnostician` → `deepseek-v4-pro`; `planner`/`security-reviewer` → `minimax-m3`; `executor` → `mimo-v2.5`.
- **Ejecucion de volumen**: `test-architect` y `devops-architect` quedaron en `mimo-v2.5` (junto a `executor` y `git-executor`).
- **deepseek-v4-pro vuelve a codigo pesado**: `refactor`, `database-architect`, `bug-diagnostician`.
- **minimax-m3 recupera planning**: `planner` y `security-reviewer` vuelven; minimax-m3 queda con planning, gobernanza, descomposicion y curacion.

---

## Resumen de Cambios (2026-08-16)

### Cambio: Consolidacion a SOLO modelos Go (5 modelos)

- **DeepSeek V4 Pro desbloqueado**: Ahora estable al optar por servidores alojados en China. Asignado a codigo pesado (refactor, database-architect, bug-diagnostician).
- **hy3 incorporado**: Nuevo modelo del plan Go. Asignado a review, requerimientos, documentacion y pruebas funcionales.
- **minimax-m3 ampliado**: Ahora cubre ejecucion de codigo, tests, planning, gobernanza, devops, descomposicion y curacion de contexto.
- **glm-5.2 retirado**: Sus 7 agentes se redistribuyeron entre minimax-m3, hy3, deepseek-v4-pro y gpt-5.6-luna.
- **kimi-k3 (Zen) retirado**: Orquestacion migrada a gpt-5.6-luna (Go). El ecosistema opera 100% con modelos Go.

### Estado final

| Categoria | Modelo | Agentes |
|-----------|--------|---------|
| Orquestacion + Arquitectura macro | `gpt-5.6-luna` (Go) | 2 agentes |
| Validacion + Remediacion + QA + Patrones + Curacion + Docs + Review + Seguridad | `muse-spark-1.2-contributor` (Go) | 10 agentes |
| Codigo pesado + architect-executor + RCA | `deepseek-v4-pro` (Go) | 4 agentes |
| Planning + Gobernanza OpenAPI + Descomposicion | `minimax-m3` (Go) | 3 agentes |
| Ejecucion de volumen + Git + Tests + DevOps | `mimo-v2.5` (Go) | 4 agentes |
| UI/E2E | `hy3` (Go) | 1 agente |
| HyprMind (orquestacion personal) | `gpt-5.6-luna` (Go) | 3 agentes |

---

## Politica de Fallback Rapida

Si un modelo falla 3+ veces consecutivas:

- **Codigo pesado** (`deepseek-v4-pro`): Degradar a `opencode-go/minimax-m3`.
- **Ejecucion de volumen + git** (`mimo-v2.5`): Degradar a `opencode-go/minimax-m3`.
- **Validacion/Arquitectura/Orquestacion** (`gpt-5.6-luna`): Escalar al usuario. NO degradar la validacion a otro modelo.
- **Validacion/QA/Patrones/Curacion/Docs/Review** (`muse-spark-1.2-contributor`): Degradar temporalmente a `opencode-go/gpt-5.6-luna` y escalar al usuario.
- **Planning/Review** (`minimax-m3` / `hy3`): Alternar entre `minimax-m3` y `hy3`.
- **Muse Spark** (`muse-spark-1.2-contributor`): Si falla validacion/QA, degradar a `gpt-5.6-luna`; si falla curacion/docs/review, alternar con `hy3` o `minimax-m3`.
