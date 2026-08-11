---
name: model-tier-routing
description: Política de escalamiento de modelos por niveles (Tiers) optimizada para maximizar la relación costo/beneficio y calidad en OpenCode.
---

# Model Tier Routing Skill

Esta skill define la asignación oficial de modelos de IA por niveles de complejidad (Tiers) para maximizar la eficiencia costo/beneficio sin comprometer el rigor del desarrollo ni la validación.

---

## Pirámide de Escalamiento de Modelos

```
                  ┌──────────────────────────────────────────┐
                  │ Tier 6: Orquestación (kimi-k3)            │
                  ├──────────────────────────────────────────┤
                  │ Tier 5: Arquitectura (deepseek-v4-pro)   │
                  ├──────────────────────────────────────────┤
                  │ Tier 4: Análisis & RCA (glm-5.2)         │
                  ├──────────────────────────────────────────┤
                  │ Tier 3: Planificación & Review (gpt-terra)│
                  ├──────────────────────────────────────────┤
                  │ Tier 2: Validación SDD (gpt-luna)        │
                  ├──────────────────────────────────────────┤
                  │ Tier 1: Obreros Rápidos (deepseek-v4-flash)│
                  └──────────────────────────────────────────┘
```

---

## Nivel 1: Obreros Rápidos & Ejecución en Código (`opencode-go/deepseek-v4-flash`)
**Uso:** Mecanografía rápida, tareas atómicas con specs claras, infraestructura y operaciones Git.
- `executor`: Implementación técnica cuando EXISTE spec SDD aprobada.
- `devops-architect`: Dockerfiles, CI/CD, docker-compose y observabilidad.
- `database-architect`: Tablas SQL, scripts Flyway y migraciones sin inactividad.
- `test-architect`: Generación de suites de unit/integration testing.
- `spec-remediator`: Corrección iterativa de hallazgos mecánicos de spec.
- `functional-tester-agent`: Ejecución de pruebas UI/E2E con Puppeteer MCP.
- `git-executor`: Operaciones exclusivas de Git (`add`, `commit`, `push`).
- `documentation`: Gestión de READMEs, ADRs y diagramas Mermaid.

---

## Nivel 2: Validación SDD, Descomposición & Refactor (`opencode-go/gpt-5.6-luna`)
**Uso:** Auditoría estricta de consistencia en especificaciones, curado de contexto y atomización de tareas.
- `spec-validator`: Validación estricta de especificaciones locales y veredicto `ready`.
- `enterprise-spec-validator`: Validación macro de Solution Workspace y contratos inter-servicios.
- `task-decomposer`: Descomposición de specs en tareas atómicas para el ejecutor.
- `refactor`: Refactorización de código para mantenibilidad preservando comportamiento.
- `context-curator`: Filtrado y curación de contexto de alta señal.

---

## Nivel 3: Planificación, Auditoría de Código & Gobernanza (`opencode/gpt-5.6-terra`)
**Uso:** Diseño técnico de arquitectura, auditoría de código, seguridad y gobierno de APIs.
- `planner`: Diseño de incrementos Delta Spec y contratos OpenAPI.
- `reviewer`: Auditoría de código buscando bugs lógicos y architecture drift.
- `security-reviewer`: Auditoría de seguridad OWASP Top 10, JWT y Keycloak.
- `api-governance-agent`: Audita contratos OpenAPI buscando Breaking Changes y semver.

---

## Nivel 4: Análisis de Causa Raíz & Requerimientos (`opencode-go/glm-5.2`)
**Uso:** Razonamiento abstracto profundo para levantamiento de necesidades y diagnóstico de fallos complejos.
- `requirements-analyst`: Levantamiento de requerimientos funcionales y brief inicial.
- `bug-diagnostician`: Análisis de causa raíz (RCA) e inspección de logs/stack traces.
- `final-validation`: Certificación final de calidad y cobertura (>85%) previa a producción.

---

## Nivel 5: Arquitectura & Razonamiento Denso (`opencode-go/deepseek-v4-pro`)
**Uso:** Decisiones de macro-arquitectura, patrones GoF e implementación sin spec SDD formal.
- `enterprise-architect`: System Landscape global, boundaries de microservicios y Bounded Contexts.
- `solution-architect`: Selección de patrones de diseño GoF y arquitectura limpia local.
- `architect-executor`: Implementación técnica compleja y refactorización cuando NO existe spec SDD previa.

---

## Nivel 6: Orquestación Superior & Coordinación (`opencode/kimi-k3`)
**Uso:** Coordinación general del proyecto, mantenimiento de contexto global y delegación paso a paso.
- `master-orchestrator`: Mantiene el contexto de la spec y coordina la secuencia entre subagentes.
