---
name: model-tier-routing
description: Politica de escalamiento de modelos por niveles (Tiers) optimizada para maximizar la relacion costo/beneficio y calidad en OpenCode. Actualizado 2026-08-16 (Luna es primario).
---

# Model Tier Routing Skill

Esta skill define la asignacion oficial de modelos de IA por niveles de complejidad (Tiers) para maximizar la eficiencia costo/beneficio sin comprometer el rigor del desarrollo ni la validacion.

---

## Proveedores Activos

- **OpenCode Go** (`opencode-go/`): Suscripcion $10/mes, $60/mes en uso. Principal fuente de modelos para agentes de trabajo.
- **OpenCode Zen** (`opencode/`): Pay-as-you-go. Usar SOLO para orquestacion de alto nivel (kimi-k3). Evitar para tareas rutinarias.

---

## Tabla de Costo/Beneficio de Modelos Go (Agosto 2026)

| Modelo | Input/1M | Output/1M | Req/5h | SWE-Bench | Uso Recomendado |
|--------|----------|-----------|--------|-----------|-----------------|
| `gpt-5.6-luna` | $0.20 | $1.20 | 2,050 | 62.7% | **PRIMARIO**. Workers, codigo, validacion. |
| `glm-5.2` | $1.40 | $4.40 | 880 | 62.1% | Planning, review, RCA |
| `mimo-v2.5` | $0.14 | $0.28 | 30,100 | - | Tareas ultra-ligeras (git, docs simples) |
| `kimi-k2.7-code` | $0.95 | $4.00 | 1,350 | - | Alternativa coding si Luna falla |
| `minimax-m3` | $0.30 | $1.20 | 3,200 | 59.0% | Alternativa general, mas requests |
| `grok-4.5` | $2.00 | $6.00 | 120 | 64.7% | Solo emergencias criticas (quema quota) |
| `kimi-k3` (Go) | $3.00 | $15.00 | 110 | - | Solo emergencia, muy caro |

**Nota sobre Luna:** $0.20/$1.20 por 1M tokens en Go. La mitad del precio de Qwen 3.7 Plus ($0.40/$1.60). Modelo OpenAI con Responses API. Contexto de 1M tokens. SWE-Bench Pro 62.7%. Uso asignado: $15/mes (promocion 2x reportada: potencialmente $30/mes).

## Modelos Zen (Pay-as-you-go) - Usar con moderacion

| Modelo | Input/1M | Output/1M | Uso |
|--------|----------|-----------|-----|
| `kimi-k3` | $3.00 | $15.00 | Orquestacion nivel 6 |
| `gpt-5.6-luna` (Zen) | $0.20 | $1.20 | Alternativa economica Zen si Go se acaba |

---

## Modelos BLOQUEADOS (No usar bajo ninguna circunstancia)

| Modelo | Proveedor | Razon |
|--------|-----------|-------|
| `deepseek-v4-flash` | opencode-go | ROTO desde Aug 4 2026. TCP drop, 403, 400 (leading-space bug). +12 issues en GitHub. |
| `deepseek-v4-flash-free` | opencode | 503 colas llenas, respuestas vacias, bucles infinitos de compactacion. |
| `deepseek-v4-pro` | opencode-go | Evidencia de que sirve V3.2 en vez de V4 real. No confiable. |
| `deepseek-v4-pro` (China) | opencode-go | Requiere opt-in a servidores en China (ZDR incierto). |
| `qwen3.7-plus` | opencode-go | Inestabilidad ~70%. Timeouts Cloudflare 524. Retirado en favor de Luna. |
| `qwen3.6-plus` | opencode-go | Modelo legacy. Usar Luna o MiniMax M3. |

---

## Piramide de Escalamiento de Modelos (Agosto 2026)

```
                   +==========================================+
                   | Tier 6: Orquestacion (kimi-k3) [Zen]     |
                   +==========================================+
                   | Tier 5: Arquitectura (gpt-5.6-luna) [Go] |
                   | Fallback: glm-5.2                        |
                   +==========================================+
                   | Tier 4: Analisis & RCA (glm-5.2) [Go]    |
                   +==========================================+
                   | Tier 3: Planificacion & Review (glm-5.2) |
                   +==========================================+
                   | Tier 2: Validacion SDD (gpt-5.6-luna)    |
                   | Fallback: glm-5.2                        |
                   +==========================================+
                   | Tier 1: Obreros Rapidos (gpt-5.6-luna)   |
                   | Light: mimo-v2.5 | Alt: kimi-k2.7-code   |
                   +==========================================+
```

---

## Nivel 1: Obreros Rapidos & Ejecucion en Codigo

**Modelo primario:** `opencode-go/gpt-5.6-luna`
**Modelo ligero:** `opencode-go/mimo-v2.5` (git-executor)
**Modelo alternativo:** `opencode-go/kimi-k2.7-code` (coding especializado)

- `executor`: `opencode-go/gpt-5.6-luna` - Implementacion con spec SDD. Si falla, usar `opencode-go/kimi-k2.7-code`.
- `devops-architect`: `opencode-go/gpt-5.6-luna` - Dockerfiles, CI/CD.
- `database-architect`: `opencode-go/gpt-5.6-luna` - Tablas SQL, Flyway, migraciones.
- `test-architect`: `opencode-go/gpt-5.6-luna` - Suites de testing.
- `spec-remediator`: `opencode-go/gpt-5.6-luna` - Correccion de hallazgos de spec.
- `functional-tester-agent`: `opencode-go/gpt-5.6-luna` - Pruebas UI/E2E con Puppeteer MCP.
- `git-executor`: `opencode-go/mimo-v2.5` - Git add/commit/push. Operaciones mecanicas.
- `documentation`: `opencode-go/gpt-5.6-luna` - READMEs, ADRs, diagramas. Requiere calidad de lenguaje.

---

## Nivel 2: Validacion SDD, Descomposicion & Refactor

**Modelo primario:** `opencode-go/gpt-5.6-luna`
**Modelo alternativo:** `opencode-go/glm-5.2`

- `spec-validator`: `opencode-go/gpt-5.6-luna` - Validacion de especificaciones locales.
- `enterprise-spec-validator`: `opencode-go/gpt-5.6-luna` - Validacion macro de Solution Workspace.
- `task-decomposer`: `opencode-go/gpt-5.6-luna` - Descomposicion en tareas atomicas.
- `refactor`: `opencode-go/gpt-5.6-luna` - Refactorizacion preservando comportamiento.
- `context-curator`: `opencode-go/gpt-5.6-luna` - Curacion de contexto de alta senal.

---

## Nivel 3: Planificacion, Auditoria de Codigo & Gobernanza

**Modelo primario:** `opencode-go/glm-5.2`

- `planner`: Diseno de incrementos Delta Spec y contratos OpenAPI.
- `reviewer`: Auditoria de codigo buscando bugs logicos y architecture drift.
- `security-reviewer`: Auditoria de seguridad OWASP, JWT, Keycloak.
- `api-governance-agent`: Auditoria de contratos OpenAPI (Breaking Changes, semver).

---

## Nivel 4: Analisis de Causa Raiz & Requerimientos

**Modelo primario:** `opencode-go/glm-5.2`

- `requirements-analyst`: Levantamiento de requerimientos funcionales.
- `bug-diagnostician`: Root Cause Analysis (RCA), inspeccion de logs/stack traces.
- `final-validation`: Certificacion final de calidad y cobertura (>85%).

---

## Nivel 5: Arquitectura & Razonamiento Denso

**Modelo primario:** `opencode-go/gpt-5.6-luna`
**Modelo alternativo:** `opencode-go/glm-5.2`

- `enterprise-architect`: System Landscape global, boundaries, Bounded Contexts.
- `solution-architect`: Seleccion de patrones GoF y arquitectura limpia.
- `architect-executor`: Implementacion compleja SIN spec SDD previa.

---

## Nivel 6: Orquestacion Superior & Coordinacion

**Modelo:** `opencode/kimi-k3` (Zen, pay-as-you-go)
**Advertencia de costo:** $3.00/$15.00 por 1M tokens. Usar solo para sesiones de orquestacion de alto nivel.

- `master-orchestrator`: Contexto global, delegacion paso a paso. Usar `opencode/kimi-k3`.
- `hyprmind-orchestrator`: V.I.E.R.N.E.S., asistente tactico de Cris. Usar `opencode/kimi-k3`.

---

## Agentes HyprMind (Modelo Go)

**Modelo:** `opencode-go/gpt-5.6-luna`

- `hyprmind-vision-analyst`: Analisis de capturas de pantalla (Ojo Bionico).
- `hyprmind-deep-thinker`: Razonamiento denso, filosofia, diseno abstracto.

---

## Politica de Fallback

Si el modelo primario de un agente falla repetidamente (3+ errores consecutivos):

1. Workers (Tier 1): Degradar de `gpt-5.6-luna` a `kimi-k2.7-code` si es tarea de codigo, o a `mimo-v2.5` si es tarea ligera.
2. Validacion (Tier 2): Degradar de `gpt-5.6-luna` a `glm-5.2`.
3. Planeacion/Review (Tier 3, 4): `glm-5.2` es el unico. Si falla, escalar al usuario.
4. Arquitectura (Tier 5): Degradar de `gpt-5.6-luna` a `glm-5.2`.
5. Orquestacion (Tier 6): `kimi-k3` es el unico en Zen. No hay fallback automatico.

---

## Notas de LatAm

- **GPT 5.6 Luna** se sirve desde US/EU/Singapur. Para LatAm, la ruta US deberia tener latencia aceptable.
- **Horas pico DeepSeek**: 01:00-04:00 y 06:00-10:00 UTC. En LatAm (UTC-5 a UTC-3) esto coincide con tarde/noche.
- **MiMo V2.5**: Reportes de 403 en algunas regiones (#40343). Verificar acceso antes de depender de el.
- **GPT 5.6 Luna**: Usa Responses API de OpenAI. Retencion de logs por 30 dias (monitoreo de abuso). No usar para codigo ultra-sensible.
