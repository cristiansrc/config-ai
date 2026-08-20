---
name: model-tier-routing
description: Politica de escalamiento de modelos por niveles (Tiers) optimizada para maximizar la relacion costo/beneficio y calidad en OpenCode. Actualizado 2026-08-17 (modelos Go: luna, hy3, deepseek-v4-pro, minimax-m3, mimo-v2.5; flash bloqueado).
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
| `gpt-5.6-luna` | $0.20 | $1.20 | 2,050 | 62.7% | **PRIMARIO**. Orquestacion, arquitectura, validacion, QA final. |
| `hy3` | N/D | N/D | N/D | N/D | Revisión, requerimientos, documentacion, pruebas funcionales. |
| `deepseek-v4-pro` | N/D | N/D | N/D | N/D | **Coding** (estable via servidores China). |
| `deepseek-v4-flash` | N/D | N/D | N/D | N/D | **BLOQUEADO** (rollback 2026-08-17). |
| `minimax-m3` | $0.30 | $1.20 | 3,200 | 59.0% | Planning, review de seguridad/gobernanza, descomposicion, curacion. |
| `mimo-v2.5` | $0.14 | $0.28 | 30,100 | - | Ultra-ligero. Ejecucion de volumen (executor, tests, devops) + git. |

**Nota sobre Luna:** $0.20/$1.20 por 1M tokens en Go. Modelo OpenAI con Responses API. Contexto de 1M tokens. SWE-Bench Pro 62.7%. Vision multimodal. Uso asignado: $15/mes (promocion 2x reportada: potencialmente $30/mes).

**Nota sobre DeepSeek V4 Pro:** Anteriormente bloqueado (servia V3.2 en vez de V4 real). Ahora ESTABLE al optar por servidores alojados en China. Asignado a los obreros de codigo pesado (refactor, database-architect, bug-diagnostician).

**Nota sobre DeepSeek V4 Flash:** Estuvo ROTO desde Aug 4 (TCP drop, 403, 400). Se habilito y volvio a molestar; rollback 2026-08-17. BLOQUEADO.

**Nota sobre hy3:** Modelo nuevo incorporado al reparto Go. Asignado a tareas de calidad media (review, requerimientos, documentacion, pruebas funcionales) donde un costo menor compensa una capacidad de razonamiento ligeramente inferior a Luna.

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

## Piramide de Escalamiento de Modelos (Agosto 2026)

```
                   +==============================================+
                   | Tier 6: Orquestacion (gpt-5.6-luna) [Go]    |
                   +==============================================+
                   | Tier 5: Arquitectura (gpt-5.6-luna) [Go]    |
                   +==============================================+
                   | Tier 4: Analisis & RCA (deepseek-v4-pro)    |
                   | QA final: gpt-5.6-luna                      |
                   +==============================================+
                   | Tier 3: Planificacion & Review               |
                   | minimax-m3 | hy3                            |
                   +==============================================+
                   | Tier 2: Validacion SDD (gpt-5.6-luna)       |
                   | Descomposicion/Curacion: minimax-m3         |
                   +==============================================+
                   | Tier 1: Obreros Codigo (mimo-v2.5)          |
                   | Pesado: deepseek-v4-pro                     |
                   +==============================================+
```

---

## Nivel 1: Obreros Rapidos & Ejecucion en Codigo

**Modelo de ejecucion de volumen:** `opencode-go/mimo-v2.5` (executor, tests, devops, git)
**Modelo pesado (refactor/DB/RCA):** `opencode-go/deepseek-v4-pro` (estable via China)

- `executor`: `opencode-go/mimo-v2.5` - Implementacion con spec SDD.
- `test-architect`: `opencode-go/mimo-v2.5` - Suites de testing.
- `devops-architect`: `opencode-go/mimo-v2.5` - Dockerfiles, CI/CD.
- `git-executor`: `opencode-go/mimo-v2.5` - Git add/commit/push. Operaciones mecanicas.
- `refactor`: `opencode-go/deepseek-v4-pro` - Refactorizacion preservando comportamiento.
- `database-architect`: `opencode-go/deepseek-v4-pro` - Tablas SQL, Flyway, migraciones.

---

## Nivel 2: Validacion SDD, Descomposicion & Curacion

**Modelo primario:** `opencode-go/gpt-5.6-luna` (validacion y remediacion)
**Modelo de soporte:** `opencode-go/minimax-m3` (descomposicion y curacion)

- `spec-validator`: `opencode-go/gpt-5.6-luna` - Validacion de especificaciones locales. **Modelo oficial bloqueado por spec-remediation.**
- `enterprise-spec-validator`: `opencode-go/gpt-5.6-luna` - Validacion macro de Solution Workspace.
- `spec-remediator`: `opencode-go/gpt-5.6-luna` - Correccion de hallazgos de spec.
- `task-decomposer`: `opencode-go/minimax-m3` - Descomposicion en tareas atomicas.
- `context-curator`: `opencode-go/minimax-m3` - Curacion de contexto de alta senal.

---

## Nivel 3: Planificacion, Auditoria de Codigo & Gobernanza

**Modelo primario:** `opencode-go/minimax-m3`
**Modelo alternativo:** `opencode-go/hy3`

- `planner`: `opencode-go/minimax-m3` - Diseno de incrementos Delta Spec y contratos OpenAPI.
- `security-reviewer`: `opencode-go/minimax-m3` - Auditoria de seguridad OWASP, JWT, Keycloak.
- `api-governance-agent`: `opencode-go/minimax-m3` - Auditoria de contratos OpenAPI (Breaking Changes, semver).
- `reviewer`: `opencode-go/hy3` - Auditoria de codigo buscando bugs logicos y architecture drift.

---

## Nivel 4: Analisis de Causa Raiz, Requerimientos & QA Final

- `bug-diagnostician`: `opencode-go/deepseek-v4-pro` - Root Cause Analysis (RCA), inspeccion de logs/stack traces.
- `requirements-analyst`: `opencode-go/hy3` - Levantamiento de requerimientos funcionales.
- `final-validation`: `opencode-go/gpt-5.6-luna` - Certificacion final de calidad y cobertura (>85%).

---

## Nivel 5: Arquitectura & Razonamiento Denso

**Modelo primario:** `opencode-go/gpt-5.6-luna`

- `enterprise-architect`: System Landscape global, boundaries, Bounded Contexts.
- `solution-architect`: Seleccion de patrones GoF y arquitectura limpia.
- `architect-executor`: Implementacion compleja SIN spec SDD previa.

---

## Nivel 6: Orquestacion Superior & Coordinacion

**Modelo:** `opencode-go/gpt-5.6-luna` (Go, primario)

- `master-orchestrator`: Contexto global, delegacion paso a paso.
- `hyprmind-orchestrator`: V.I.E.R.N.E.S., asistente tactico de Cris.

---

## Agentes de Soporte (hy3)

**Modelo:** `opencode-go/hy3`

- `documentation`: READMEs, ADRs, diagramas. Calidad de lenguaje.
- `functional-tester-agent`: Pruebas UI/E2E con Puppeteer MCP.

---

## Agentes HyprMind (Modelo Go)

**Modelo:** `opencode-go/gpt-5.6-luna`

- `hyprmind-vision-analyst`: Analisis de capturas de pantalla (Ojo Bionico). Requiere vision multimodal.
- `hyprmind-deep-thinker`: Razonamiento denso, filosofia, diseno abstracto.

---

## Politica de Fallback

Si el modelo primario de un agente falla repetidamente (3+ errores consecutivos):

1. Workers (Tier 1): Si `mimo-v2.5` falla, degradar a `minimax-m3`; si `deepseek-v4-pro` falla, degradar a `minimax-m3`.
2. Validacion (Tier 2): `gpt-5.6-luna` es el unico autorizado para validar. Si falla, escalar al usuario (NO degradar la validacion a otro modelo).
3. Planeacion/Review (Tier 3): Degradar de `minimax-m3` a `hy3` o viceversa.
4. Arquitectura/Orquestacion (Tier 5, 6): `gpt-5.6-luna` es el unico. Si falla, escalar al usuario.

---

## Notas de LatAm

- **GPT 5.6 Luna** se sirve desde US/EU/Singapur. Para LatAm, la ruta US deberia tener latencia aceptable.
- **DeepSeek V4 Pro**: Se sirve desde servidores en China (requiere opt-in). Latencia mayor pero estable. Ideal para tareas de codigo no interactivas en tiempo real.
- **DeepSeek V4 Flash**: BLOQUEADO por rollback 2026-08-17 (volvio a molestar: TCP drop, 403, 400).
- **MiMo V2.5**: Reportes de 403 en algunas regiones (#40343). Verificar acceso antes de depender de el.
- **GPT 5.6 Luna**: Usa Responses API de OpenAI. Retencion de logs por 30 dias (monitoreo de abuso). No usar para codigo ultra-sensible.
