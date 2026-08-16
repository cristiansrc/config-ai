# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-08-16 (Migracion qwen3.7-plus → gpt-5.6-luna)

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.jsonc`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/active/opencode/agents/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/active/opencode/skills/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Idioma obligatorio: Todas las respuestas e interacciones de los agentes con el usuario deben ser en ESPANOL.
- Politica de idioma de agentes: La definicion operativa, responsabilidades, reglas y guias de cada agente deben estar en ESPANOL. Se mantienen en INGLES los nombres de agentes/skills, estados canonicos, headings, rutas, comandos, campos de protocolo y tokens exactos como `ready`, `blocked`, `validated-not-executed`, `## Spec Validator Approval` o `Blocked: ...`.
- Contratos de error por stack: Spring Boot Java usa `springboot-java-rest-error-response-standards`, Spring Boot Kotlin usa `springboot-kotlin-rest-error-response-standards` y FastAPI usa `fastapi-rest-error-response-standards`.
- Convenciones de stack: `nodejs-stack`, `python-stack`, `fastapi-stack`, `springboot-stack`, `java-stack`, `kotlin-stack` y `golang-stack` son la fuente de verdad para reglas tecnicas de cada runtime.
- Estandar de Testing Funcional: `functional-testing-standard` define la estrategia de planeacion, reporte y correccion de pruebas UI/E2E en frontends utilizando Puppeteer MCP o frameworks locales.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.
- Cambio operativo vigente: Spec Remediator debe invocar validaciones solo mediante `spec-validator` con `opencode-go/gpt-5.6-luna`; cualquier validacion ejecutada con otro modelo debe bloquearse como `Blocked: wrong validator model`.
- Estandares de Calidad y Pruebas Avanzadas: `code-quality-and-sonarqube` (SonarScanner, SpotBugs, Ruff, golangci-lint, script ./verify-code.sh), `performance-testing-k6` (k6 load testing, p95 < 200ms), `eval-ops-agent-benchmarks` (benchmarks de regresion de agentes), `zero-downtime-migrations` (Expand/Contract DB), `root-cause-analysis` (RCA protocol), `api-governance-linter` (OpenAPI breaking changes) y `testing-strategy` (TDD Red-Green-Refactor, ArchUnit, Concurrencia).
- Estructura de Solution Workspace (OPCIONAL): La pertenencia a un Solution Workspace esta condicionada a que la carpeta padre del proyecto se llame exactamente `projects/`.
- Gestion de Paquetes JS/TS: Queda ESTRICTAMENTE PROHIBIDO el uso de `npm` para cualquier tarea (Node, React, Angular, etc.). Se debe utilizar exclusivamente `pnpm`.
- Soporte de Contexto mediante Grafos (Graphify): Para optimizar el contexto de los agentes, reducir el consumo de tokens y asegurar la trazabilidad arquitectonica, se utiliza Graphify en los proyectos compatibles.
- Aislamiento Operativo de Git: Queda ESTRICTAMENTE PROHIBIDO para todos los agentes de desarrollo, pruebas o documentacion ejecutar cualquier comando Git. Toda operacion Git debe delegarse exclusivamente al agente `git-executor`.

---

## BLOQUEO DE MODELOS (Agosto 2026)

| Modelo | Razon | Fuente |
|--------|-------|--------|
| `opencode-go/deepseek-v4-flash` | TCP drop, 403, 400, cuelgues. ROTO desde Aug 4 | GitHub #40465, #40485, #41306 |
| `opencode/deepseek-v4-flash-free` | 503 cola llena, bucles infinitos, resp vacias | GitHub #40254, #30443 |
| `opencode-go/deepseek-v4-pro` | Sirve V3.2 en vez de V4 real. No confiable | GitHub #40409 |
| `opencode-go/qwen3.7-plus` | Inestabilidad 70%. Timeouts Cloudflare 524. **Retirado.** | GitHub #32418, #33721 |

---

## Estado de Modelos Go (Agosto 2026)

| Modelo | Req/5h | Costo 1M in/out | SWE-Bench | Notas |
|--------|--------|-----------------|-----------|-------|
| **gpt-5.6-luna** | 2,050 | $0.20/$1.20 | 62.7% | **PRIMARIO**. OpenAI, 1M ctx. Promo 2x usage. |
| glm-5.2 | 880 | $1.40/$4.40 | 62.1% | Planning, review, RCA. Confiable. |
| mimo-v2.5 | 30,100 | $0.14/$0.28 | - | Ultra-ligero. git-executor. |
| kimi-k2.7-code | 1,350 | $0.95/$4.00 | - | Alternativa coding. |
| minimax-m3 | 3,200 | $0.30/$1.20 | 59.0% | Alternativa general. |

Perfil LM Studio persistente:
- `lmstudio/qwen/qwen3.6-35b-a3b`: context length `152563`, GPU offload ratio `26/64` capas, K/V cache `Q4_0`. OpenCode declara el mismo limite de contexto.

---

## Tabla de Agentes y Modelos (Actualizada 2026-08-16)

| Agente | Modelo | Proveedor | Editar | Bash | Descripcion |
|--------|--------|-----------|--------|------|-------------|
| api-governance-agent | opencode-go/glm-5.2 | Go | deny | allow | Audita contratos OpenAPI buscando Breaking Changes, backward compatibility y reglas semver. |
| architect-executor | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Implementa tareas complejas y arquitectura local cuando NO existe especificacion SDD completa. |
| bug-diagnostician | opencode-go/glm-5.2 | Go | deny | allow | Realiza analisis de causa raiz (RCA) e inspeccion de logs/stack traces. |
| context-curator | **opencode-go/gpt-5.6-luna** | Go | deny | deny | Gestiona la ventana de contexto (Temp 0.10) y reduce ruido. |
| database-architect | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Disena esquemas DB, migraciones Flyway/Liquibase e indices Zero-Downtime. |
| devops-architect | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Infraestructura como Codigo, Docker, CI/CD. |
| documentation | **opencode-go/gpt-5.6-luna** | Go | allow | deny | Gestiona documentacion siguiendo `documentation-lifecycle` y `documentation-standards`. |
| enterprise-architect | **opencode-go/gpt-5.6-luna** | Go | allow | deny | System Landscape, fronteras de microservicios. **Fallback: glm-5.2** |
| enterprise-spec-validator | **opencode-go/gpt-5.6-luna** | Go | allow | deny | Valida coherencia global del Solution Workspace. |
| executor | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Implementa codigo (Temp 0.15) cuando EXISTE spec SDD validada. **Alt: kimi-k2.7-code** |
| final-validation | opencode-go/glm-5.2 | Go | deny | allow | Calidad final y cobertura minima siguiendo `testing-strategy` y `pre-flight-check`. |
| functional-tester-agent | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Pruebas funcionales y UI/E2E con Puppeteer MCP. |
| git-executor | opencode-go/mimo-v2.5 | Go | allow | allow | Operaciones Git exclusivas (ramas, commits, push). **Modelo ligero para ahorrar quota.** |
| master-orchestrator | opencode/kimi-k3 | **Zen** | deny | allow | Orquestador Contextual. Mantiene contexto de spec y delega. **Zen pay-as-you-go.** |
| planner | opencode-go/glm-5.2 | Go | allow | deny | Planifica incrementos SDD y disena contratos OpenAPI. |
| refactor | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Refactoriza codigo siguiendo `refactor-patterns` y `refactor-hexagonal-bridge`. |
| requirements-analyst | opencode-go/glm-5.2 | Go | allow | deny | Levantamiento de requerimientos funcionales. |
| reviewer | opencode-go/glm-5.2 | Go | deny | allow | Audita codigo buscando drift y bugs. |
| security-reviewer | opencode-go/glm-5.2 | Go | deny | allow | Valida postura de seguridad OWASP, JWT, Keycloak. |
| solution-architect | **opencode-go/gpt-5.6-luna** | Go | allow | deny | Elige patrones de diseno GoF. **Fallback: glm-5.2** |
| spec-remediator | **opencode-go/gpt-5.6-luna** | Go | allow | deny | Corrige hallazgos de validacion de forma iterativa. |
| spec-validator | **opencode-go/gpt-5.6-luna** | Go | allow limitado | deny | Valida consistencia de artefactos SDD. |
| task-decomposer | **opencode-go/gpt-5.6-luna** | Go | allow | deny | Descompone especificaciones en tareas atomicas. |
| test-architect | **opencode-go/gpt-5.6-luna** | Go | allow | allow | Disena estrategia de pruebas y genera casos de test. |
| hyprmind-orchestrator | opencode/kimi-k3 | **Zen** | allow | allow | V.I.E.R.N.E.S. Orquestador conversacional. **Zen pay-as-you-go.** |
| hyprmind-vision-analyst | **opencode-go/gpt-5.6-luna** | Go | deny | deny | Ojo Bionico. Analisis de capturas de pantalla. |
| hyprmind-deep-thinker | **opencode-go/gpt-5.6-luna** | Go | deny | deny | Razonamiento denso, filosofia, diseno abstracto. |

---

## Resumen de Cambios (2026-08-16)

### Cambio 1 (primer pase): DeepSeek fuera, MiMo para git
- `git-executor`: `qwen3.7-plus` → `mimo-v2.5` (ahorro de quota)
- `model-tier-routing SKILL.md`: Reescritura con bloqueos y fallbacks
- DeepSeek V4 Flash/Pro: Bloqueados

### Cambio 2 (segundo pase): Migracion qwen3.7-plus → gpt-5.6-luna
- **17 agentes** migrados de `opencode-go/qwen3.7-plus` a `opencode-go/gpt-5.6-luna`
- Luna: $0.20/$1.20 vs Qwen $0.40/$1.60 (**50% mas barato**)
- Luna: SWE-Bench Pro 62.7%, 1M contexto, OpenAI Responses API
- Luna: 2,050 req/5h (suficiente para uso interactivo)
- Promocion "2x usage" reportada en algunos listings (potencialmente $30/mes en vez de $15)

### Estado final
| Categoria | Modelo | Agentes |
|-----------|--------|---------|
| Workers + Validacion + Arquitectura | `gpt-5.6-luna` (Go) | 17 agentes |
| Planning + Review + RCA | `glm-5.2` (Go) | 7 agentes |
| Git | `mimo-v2.5` (Go) | 1 agente |
| Orquestacion | `kimi-k3` (Zen) | 2 agentes |

---

## Politica de Fallback Rapida

Si GPT 5.6 Luna falla 3+ veces consecutivas:
- **Ejecucion de codigo**: Cambiar a `opencode-go/kimi-k2.7-code`
- **Validacion/Arquitectura**: Cambiar a `opencode-go/glm-5.2`
- **Tareas ligeras**: Cambiar a `opencode-go/mimo-v2.5`

Si Kimi K3 (Zen) esta consumiendo demasiado credito:
- Evaluar si la orquestacion puede hacerla `opencode-go/glm-5.2`
