---
name: model-tier-routing
description: Politica de escalamiento de modelos por niveles (Tiers) optimizada para maximizar la relacion costo/beneficio y calidad en OpenCode. Actualizado 2026-08-20 (modelos Go: luna, muse-spark-1.2-contributor, hy3, deepseek-v4-pro, minimax-m3, mimo-v2.5; flash bloqueado).
---

# Model Tier Routing Skill

Esta skill define la asignacion oficial de modelos de IA por niveles de complejidad (Tiers) para maximizar la eficiencia costo/beneficio sin comprometer el rigor del desarrollo ni la validacion.

---

## Proveedores Activos

- **OpenCode Go** (`opencode-go/`): Suscripcion $10/mes, $60/mes en uso. Unica fuente de modelos para agentes de trabajo. Se usan SOLO modelos Go.
- **OpenCode Zen** (`opencode/`): Retirado del reparto. Ya no se usa para orquestacion (kimi-k3 migrado a Go).

---

## Tabla de Costo/Beneficio de Modelos Go (Agosto 2026)

| Modelo | Input/1M | Output/1M | Req/5h | SWE-Bench | Uso Recomendado |
|--------|----------|-----------|--------|-----------|-----------------|
| `gpt-5.6-luna` | $0.20 | $1.20 | 2,050 | 62.7% | **PRIMARIO**. Orquestacion macro, arquitectura enterprise. |
| `muse-spark-1.2-contributor` | N/D | N/D (bajo) | N/D | N/D | **Muse Spark**. Validacion, remediacion, QA, patrones GoF, curacion, docs, review, seguridad. 1M contexto, costo mínimo. |
| `hy3` | N/D | N/D | N/D | N/D | UI/E2E (functional-tester-agent). |
| `deepseek-v4-pro` | N/D | N/D | N/D | N/D | **Coding pesado** + architect-executor (estable via servidores China). |
| `deepseek-v4-flash` | N/D | N/D | N/D | N/D | **BLOQUEADO** (rollback 2026-08-17). |
| `minimax-m3` | $0.30 | $1.20 | 3,200 | 59.0% | Planning, gobernanza OpenAPI, descomposicion. |
| `mimo-v2.5` | $0.14 | $0.28 | 30,100 | - | Ultra-ligero. Ejecucion de volumen (executor, tests, devops) + git. |

**Nota sobre Luna:** $0.20/$1.20 por 1M tokens en Go. Modelo OpenAI con Responses API. Contexto de 1M tokens. SWE-Bench Pro 62.7%. Vision multimodal. Uso asignado: $15/mes (promocion 2x reportada: potencialmente $30/mes).

**Nota sobre DeepSeek V4 Pro:** Anteriormente bloqueado (servia V3.2 en vez de V4 real). Ahora ESTABLE al optar por servidores alojados en China. Asignado a los obreros de codigo pesado (refactor, database-architect, bug-diagnostician).

**Nota sobre DeepSeek V4 Flash:** Estuvo ROTO desde Aug 4 (TCP drop, 403, 400). Se habilito y volvio a molestar; rollback 2026-08-17. BLOQUEADO.

**Nota sobre hy3:** Modelo Go asignado a tareas de pruebas funcionales UI/E2E (functional-tester-agent) donde un costo menor compensa razonamiento ligero.

**Nota sobre Muse Spark (muse-spark-1.2-contributor):** Migrado el 2026-08-20 desde Luna/M3/hy3 para validacion, remediacion, QA, patrones GoF, curacion, documentacion, review y seguridad. Ventana 1M tokens, razonamiento superior a Luna en patrones y seguridad, costo casi nulo.

**Nota sobre DeepSeek V4 Pro + architect-executor:** Desde 2026-08-20, `architect-executor` migrado de Luna a DeepSeek V4 Pro para codigo complejo sin spec SDD (más preciso y económico que Luna).

---

## Modelos BLOQUEADOS (No usar bajo ninguna circunstancia)

| Modelo | Proveedor | Razon |
|--------|-----------|-------|
| `deepseek-v4-flash` | opencode-go | ROTO desde Aug 4 2026. TCP drop, 403, 400 (leading-space bug). Rollback 2026-08-17. |
| `deepseek-v4-flash-free` | opencode | 503 colas llenas, respuestas vacias, bucles infinitos de compactacion. |
| `qwen3.7-plus` | opencode-go | Inestabilidad ~70%. Timeouts Cloudflare 524. Retirado en favor de Luna. |
| `qwen3.6-plus` | opencode-go | Modelo legacy. Usar Luna o MiniMax M3. |

**Modelos retirados del reparto (no rotos, solo reemplazados):**

| Modelo | Proveedor | Razon |
|--------|-----------|-------|
| `glm-5.2` | opencode-go | Reemplazado por minimax-m3 / hy3 para planning, review y RCA. |
| `kimi-k3` | opencode (Zen) | Orquestacion migrada a gpt-5.6-luna (Go). Zen fuera del reparto. |

---

## Piramide de Escalamiento de Modelos (Agosto 2026 - Actualizado 2026-08-20)

```
                   +==============================================+
                   | Tier 6: Orquestacion (gpt-5.6-luna) [Go]    |
                   +==============================================+
                   | Tier 5: Arquitectura macro (gpt-5.6-luna)   |
                   | Patrones GoF: muse-spark-1.2-contributor    |
                   +==============================================+
                   | Tier 4: Analisis & RCA (deepseek-v4-pro)    |
                   | QA final: muse-spark-1.2-contributor        |
                   +==============================================+
                   | Tier 3: Planificacion (minimax-m3)          |
                   | Gobernanza OpenAPI: minimax-m3 | hy3→spark |
                   +==============================================+
                   | Tier 2: Validacion SDD (muse-spark)         |
                   | Remediacion: muse-spark | Descomp: minimax  |
                   | Curacion: muse-spark                        |
                   +==============================================+
                   | Tier 1: Obreros Codigo (mimo-v2.5)          |
                   | Pesado: deepseek-v4-pro (incl. arch-exec)   |
                   +==============================================+
```

---

## Nivel 1: Obreros Rapidos & Ejecucion en Codigo

**Modelo de ejecucion de volumen:** `opencode-go/mimo-v2.5` (executor, tests, devops, git)
**Modelo pesado (refactor/DB/RCA/arch-exec):** `opencode-go/deepseek-v4-pro` (estable via China)

- `executor`: `opencode-go/mimo-v2.5` - Implementacion con spec SDD.
- `test-architect`: `opencode-go/mimo-v2.5` - Suites de testing.
- `devops-architect`: `opencode-go/mimo-v2.5` - Dockerfiles, CI/CD.
- `git-executor`: `opencode-go/mimo-v2.5` - Git add/commit/push. Operaciones mecanicas.
- `refactor`: `opencode-go/deepseek-v4-pro` - Refactorizacion preservando comportamiento.
- `database-architect`: `opencode-go/deepseek-v4-pro` - Tablas SQL, Flyway, migraciones.
- `architect-executor`: `opencode-go/deepseek-v4-pro` - Codigo complejo SIN spec SDD (migrado de gpt-5.6-luna el 2026-08-20).

---

## Nivel 2: Validacion SDD, Descomposicion & Curacion (Actualizado 2026-08-20)

**Modelo primario:** `opencode-go/muse-spark-1.2-contributor` (validacion, remediacion, curacion)
**Modelo de soporte descomposicion:** `opencode-go/minimax-m3`

- `spec-validator`: `opencode-go/muse-spark-1.2-contributor` - Validacion de especificaciones locales. **Modelo oficial bloqueado por spec-remediation (migrado de gpt-5.6-luna el 2026-08-20).**
- `enterprise-spec-validator`: `opencode-go/muse-spark-1.2-contributor` - Validacion macro de Solution Workspace (migrado de gpt-5.6-luna).
- `spec-remediator`: `opencode-go/muse-spark-1.2-contributor` - Correccion de hallazgos de spec (migrado de gpt-5.6-luna).
- `context-curator`: `opencode-go/muse-spark-1.2-contributor` - Curacion de contexto de alta senal (migrado de minimax-m3, ventana 1M).
- `task-decomposer`: `opencode-go/minimax-m3` - Descomposicion en tareas atomicas (se mantiene).

---

## Nivel 3: Planificacion, Auditoria de Codigo & Gobernanza (Actualizado 2026-08-20)

**Modelo primario planning/gobernanza:** `opencode-go/minimax-m3`
**Modelo Muse Spark (review/seguridad):** `opencode-go/muse-spark-1.2-contributor`

- `planner`: `opencode-go/minimax-m3` - Diseno de incrementos Delta Spec y contratos OpenAPI. (se mantiene)
- `api-governance-agent`: `opencode-go/minimax-m3` - Auditoria de contratos OpenAPI (Breaking Changes, semver). (se mantiene)
- `task-decomposer`: `opencode-go/minimax-m3` - Ya listado en Nivel 2, se mantiene aquí por legado.
- `security-reviewer`: `opencode-go/muse-spark-1.2-contributor` - Auditoria de seguridad OWASP, JWT, Keycloak. (migrado de minimax-m3)
- `reviewer`: `opencode-go/muse-spark-1.2-contributor` - Auditoria de codigo buscando bugs logicos y architecture drift. (migrado de hy3)

---

## Nivel 4: Analisis de Causa Raiz, Requerimientos & QA Final (Actualizado 2026-08-20)

- `bug-diagnostician`: `opencode-go/deepseek-v4-pro` - Root Cause Analysis (RCA), inspeccion de logs/stack traces. (se mantiene)
- `requirements-analyst`: `opencode-go/muse-spark-1.2-contributor` - Levantamiento de requerimientos funcionales. (migrado de hy3)
- `final-validation`: `opencode-go/muse-spark-1.2-contributor` - Certificacion final de calidad y cobertura (>85%). (migrado de gpt-5.6-luna)

---

## Nivel 5: Arquitectura & Razonamiento Denso (Actualizado 2026-08-20)

**Modelo orquestacion macro:** `opencode-go/gpt-5.6-luna`
**Modelo patrones GoF / logica compleja:** `opencode-go/muse-spark-1.2-contributor` y `opencode-go/deepseek-v4-pro`

- `enterprise-architect`: `opencode-go/gpt-5.6-luna` - System Landscape global, boundaries, Bounded Contexts. (se mantiene)
- `solution-architect`: `opencode-go/muse-spark-1.2-contributor` - Seleccion de patrones GoF y arquitectura limpia. (migrado de gpt-5.6-luna)
- `architect-executor`: `opencode-go/deepseek-v4-pro` - Implementacion compleja SIN spec SDD previa. (migrado de gpt-5.6-luna)

---

## Nivel 6: Orquestacion Superior & Coordinacion

**Modelo:** `opencode-go/gpt-5.6-luna` (Go, primario)

- `master-orchestrator`: Contexto global, delegacion paso a paso.
- `hyprmind-orchestrator`: V.I.E.R.N.E.S., asistente tactico de Cris.

---

## Agentes de Soporte

**Modelo Muse Spark:** `opencode-go/muse-spark-1.2-contributor`
- `documentation`: READMEs, ADRs, diagramas. Calidad de lenguaje. (migrado de hy3)

**Modelo hy3:**
- `functional-tester-agent`: `opencode-go/hy3` - Pruebas UI/E2E con Puppeteer MCP. (se mantiene)

**Nota:** `requirements-analyst` y `reviewer` migraron a Muse Spark (ver Nivel 3 y 4).

---

## Agentes HyprMind (Modelo Go)

**Modelo:** `opencode-go/gpt-5.6-luna`

- `hyprmind-vision-analyst`: Analisis de capturas de pantalla (Ojo Bionico). Requiere vision multimodal.
- `hyprmind-deep-thinker`: Razonamiento denso, filosofia, diseno abstracto.

---

## Politica de Fallback (Actualizado 2026-08-20)

Si el modelo primario de un agente falla repetidamente (3+ errores consecutivos):

1. Workers (Tier 1): Si `mimo-v2.5` falla, degradar a `minimax-m3`; si `deepseek-v4-pro` falla, degradar a `minimax-m3` (incluye `architect-executor`).
2. Validacion/QA/Remediacion/Curacion/Patrones/Docs/Review/Seguridad (Tier 2,3,4,5 - Muse Spark): Si `muse-spark-1.2-contributor` falla, degradar temporalmente a `opencode-go/gpt-5.6-luna` y escalar al usuario. Para curacion/docs/review alternativo es `hy3`.
3. Planning/Gobernanza/Descomposicion (Tier 3 - minimax-m3): Degradar a `muse-spark-1.2-contributor` o `hy3`.
4. Orquestacion/Arquitectura macro (Tier 5, 6 - gpt-5.6-luna): `gpt-5.6-luna` es el unico. Si falla, escalar al usuario (NO degradar validacion Muse Spark a otro sin aviso).
5. UI/E2E (hy3): Alternar entre `hy3` y `muse-spark-1.2-contributor`.

---

## Notas de LatAm

- **GPT 5.6 Luna** se sirve desde US/EU/Singapur. Para LatAm, la ruta US deberia tener latencia aceptable.
- **DeepSeek V4 Pro**: Se sirve desde servidores en China (requiere opt-in). Latencia mayor pero estable. Ideal para tareas de codigo no interactivas en tiempo real.
- **DeepSeek V4 Flash**: BLOQUEADO por rollback 2026-08-17 (volvio a molestar: TCP drop, 403, 400).
- **MiMo V2.5**: Reportes de 403 en algunas regiones (#40343). Verificar acceso antes de depender de el.
- **GPT 5.6 Luna**: Usa Responses API de OpenAI. Retencion de logs por 30 dias (monitoreo de abuso). No usar para codigo ultra-sensible.
