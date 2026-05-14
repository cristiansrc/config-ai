# config-ai

Repositorio local de referencia para la configuración de IA usada con OpenCode, LM Studio, agentes especializados, skills SDD y respaldos operativos.

Última actualización documentada: 2026-05-14.

## Objetivo

Esta carpeta consolida el estado canónico del entorno de IA local:

- OpenCode como orquestador de agentes.
- Proveedores: `opencode-go` para modelos cloud de alto rendimiento y LM Studio para modelos locales.
- **Jerarquía de Arquitectura**: Integración de niveles Enterprise, Solution y Project Architecture.
- **Solution Workspace**: Gestión de múltiples repositorios bajo una visión macro-arquitectónica única.
- **Skills SDD**: 34 habilidades que cubren el ciclo de vida completo del software.
- **Políticas Globales**: Auditoría, Soft Delete, Cobertura del 85% y Naming en snake_case.

## Estructura

```text
config-ai/
|-- README.md
|-- resumen-configuracion-ia.txt
|-- agents/
|   `-- agentes-y-modelos.md
|-- skill/
|   `-- backup-20260514/ (Histórico)
|-- backups/
|   `-- full-backup-20260514-final/ <-- (Backup Actual: 34 skills + Agentes)
`-- opencode/
    `-- opencode.json (Referencia)
```

## Hardware y Modelos

- **GPU**: NVIDIA RTX 4080 de 16 GB.
- **Modelos Cloud (opencode-go)**: `qwen3.6-plus` (Reasoning), `deepseek-v4-pro` (Validation).
- **Modelos Locales (lmstudio)**: `qwen/qwen3.6-35b-a3b` (Backup & Local Processing).

## Agentes Arquitectónicos

| Agente | Nivel | Responsabilidad | Skill Principal |
|---|---|---|---|
| **enterprise-architect** | Macro | System Landscape y Bounded Contexts | `enterprise-architecture-standard` |
| **solution-architect** | Meso | Patrones de Diseño (GoF) y Estructura Local | `design-patterns-standard` |
| **planner** | Micro | Planificación SDD e Incrementos | `spec-driven-development` |

## Ecosistema de Skills (34 Skills Instaladas)

Principales categorías:
- **Arquitectura**: `hexagonal-architecture`, `openapi-first`, `restful-standard`, `enterprise-architecture-standard`, `design-patterns-standard`, `requirements-gathering`.
- **Backend Stacks**: `springboot-stack`, `fastapi-stack`, `jpa-stack`, `python-stack`, `nodejs-stack`, `spring-cloud-gateway`.
- **Bases de Datos**: `flyway-migrations`, `postgresql-standard`, `mysql-standard`, `oracle-standard`, `sqlserver-standard`.
- **Calidad y Seguridad**: `testing-strategy` (85% coverage), `pre-flight-check`, `security-standards`, `keycloak-standard`.

## Solution Workspace Pattern

Para gestionar el ecosistema, se utiliza la carpeta `proyectos/` en la raíz de los repositorios de arquitectura:
- El `.gitignore` raíz ignora `proyectos/*` para mantener aislamiento de repositorios.
- Los agentes realizan búsquedas jerárquicas hacia arriba (`../../`) para leer la **Master Spec de Solución** y asegurar alineación global.

## Convenciones Críticas

1. **Auditoría**: `created_at`, `updated_at` y `deleted` obligatorios.
2. **Soft Delete**: Prohibida la eliminación física de registros.
3. **Cobertura**: Mínimo 85% por archivo testable (JaCoCo, pytest-cov).
4. **Naming**: Consistencia total en `snake_case`.
5. **Idioma**: Comunicación con el usuario exclusivamente en **Español**.


## Skills

Directorio activo:

```text
/home/cristiansrc/.config/opencode/skills
```

Origen canonico:

```text
/home/cristiansrc/Documentos/Proyectos/shared-ai-services/skills
```

Las skills estan enlazadas por symlink desde OpenCode hacia `shared-ai-services`.

Skills instaladas:

1. `architecture/hexagonal-architecture`
2. `architecture/openapi-first`
3. `architecture/spec-driven-development`
4. `orchestration/context-pinning`
5. `orchestration/context-curation`
6. `orchestration/model-tier-routing`
7. `backend/flyway-migrations`
8. `backend/repository-dto-patterns`
9. `backend/rest-error-response-standards`
10. `quality/bug-fixing-workflow`
11. `quality/pre-flight-check`
12. `quality/refactor-hexagonal-bridge`
13. `quality/refactor-patterns`
14. `quality/code-review-checklist`
15. `quality/testing-strategy`
16. `security/security-standards`
17. `documentation/documentation-lifecycle`
18. `documentation/documentation-standards`
19. `frontend/frontend-architecture`
20. `git-ops`

Convenciones importantes:

- Master Spec consolidada: `docs/specs/master_spec.md`.
- OpenAPI canonico: ruta declarada por proyecto en spec/shared context.
- Para Spring Boot se aceptan por defecto `docs/api/openapi.yaml`, `docs/api/openapi.yml`, `src/main/resources/openapi.yaml` o `src/main/resources/openapi.yml`.
- Planner es el owner de editar OpenAPI.
- Documentation, Executor, Task Decomposer, Reviewer, Security Reviewer, Test Architect y Refactor no deben editar contratos OpenAPI.
- Spec Remediator no debe editar OpenAPI ni migraciones Flyway por defecto.

## Flujo SDD

Flujo actualizado propuesto:

```text
requirements-analyst -> planner -> spec-validator -> spec-remediator -> spec-validator -> task-decomposer -> executor -> final-validation
```

Flujo incremental pendiente por probar:

1. Crear Delta Spec en `docs/specs/increments/`.
2. Evaluar impacto en Master Spec y OpenAPI.
3. Implementar con Arquitectura Hexagonal y Pre-flight Check.
4. Consolidar documentacion y cerrar PR.

## Reglas SDD Criticas

- Toda spec debe declarar estado cerca del inicio.
- Estados editables: `planning`, `draft`, `validated-not-executed`.
- Estados no editables: `executed`, `implemented`, `closed`, `superseded`.
- Una spec ejecutada, implementada o cerrada no se modifica en sitio; se crea una nueva spec incremental.
- Task Decomposer y Executor solo avanzan si spec/shared context estan `validated-not-executed` y el ultimo Spec Validator dice `ready`.
- La aprobacion valida de Spec Validator debe estar bajo el heading exacto `## Spec Validator Approval`.
- El approval debe incluir `verdict: ready`, `reviewed_at`, `validator_agent: spec-validator`, `artifact_set_reviewed`, `summary` e `invalidated_by_changes_since: none`.
- Frases como `Ready for Task Decomposer`, `Artifacts aligned` o `all findings resolved` no cuentan como aprobacion.
- Si cualquier review summary o Spec Validator dice `not ready`, la siguiente accion obligatoria es Planner corrections + nueva validacion.
- No se debe usar `Known Technical Debt`, `Override Approved by User` ni `fix post-increment` para saltarse drift entre spec, OpenAPI o migraciones salvo aprobacion explicita del usuario registrada en shared context.
- Solo debe existir un shared context activo por incremento.
- Los checklists deben verificar archivos reales e incluir evidencia de ruta, campo, endpoint o columna revisada.
- Las rutas en `Canonical artifacts` deben existir realmente.
- El task board solo puede usar estados `todo`, `in_progress`, `done` o `blocked`.
- Si hay `Blocker:` o estado superior `blocked`, no deben quedar tareas ejecutables en `todo`.

## Responsabilidades por Agente

`requirements-analyst`
: Levanta requerimientos antes del Planner. Produce `requirements-brief.md`. No escribe OpenAPI, migraciones, task boards, specs formales ni codigo.

`planner`
: Produce specs SDD, decisiones de arquitectura, contratos OpenAPI, migraciones esperadas, configuracion e integraciones. Cuando crea o actualiza specs, debe asegurar un `.gitignore` en la raiz del repositorio activo para excluir artefactos no versionables de specs y del codigo generado.

`spec-validator`
: Valida coherencia contra spec, OpenAPI, migraciones, config/realm, task board y shared context. Puede editar solo reportes y metadatos de estado/lifecycle autorizados.

`spec-remediator`
: Corrige hallazgos mecanicos o drift seguro uno por uno. No toma decisiones de diseno, no llama a Task Decomposer ni Executor. Debe pedir validacion exclusivamente a `spec-validator` con `lmstudio/qwen3.6-27b`; si la validacion ocurre con otro modelo, debe bloquear con `Blocked: wrong validator model`.

`task-decomposer`
: Crea task boards atomicos desde specs validadas. Debe bloquear si faltan fuentes canonicas o hay terminos obsoletos.

`executor`
: Implementa codigo desde specs aprobadas y task boards validados. Debe detenerse con `Blocked: artifact mismatch` si task decomposition contradice OpenAPI, migraciones, config o spec validada.

`final-validation`
: Hace validacion final de produccion sobre specs, implementacion, tests, seguridad y documentacion.

## Backups

Backups de agentes:

```text
agents/backup-20260511-115129/
agents/backup-20260511-120114/
agents/backup-20260511-130320/
agents/backup-20260511-140434/
agents/backup-20260511-164320/
```

Backups de skills:

```text
skill/backup-20260511-115129/
skill/backup-20260511-120114/
skill/backup-20260511-130320/
```

Backups de OpenCode:

```text
opencode-backup-20260511-130320/opencode.json
opencode-backup-20260511-134933.json
```

Politica:

- Si se modifican agentes o skills, crear un nuevo backup fechado bajo `agents/` o `skill/`.
- Retener maximo 25 backups de agentes, 25 backups de skills y 25 backups de configuracion OpenCode.
- Despues de crear un backup nuevo, eliminar los backups mas viejos que excedan ese limite.
- No guardar secretos en backups.

## Mantenimiento

Cuando cambien agentes, modelos, permisos, routing o skills:

1. Actualizar `resumen-configuracion-ia.txt`.
2. Si afecta agentes/modelos/permisos, actualizar `agents/agentes-y-modelos.md`.
3. Crear backup fechado si se modificaron agentes o skills.
4. Respetar la retencion maxima de 25 backups por categoria.
5. Verificar que `opencode.json` no tenga secretos.
6. Reiniciar OpenCode si se agregaron o sincronizaron skills.

Regla especial del Planner:

- Cuando cree o actualice specs, debe crear o completar `<active-repo>/.gitignore`.
- El `.gitignore` debe cubrir `docs/specs/.working/`, secretos/env, logs, dependencias, outputs de build, coverage/test artifacts, runtime local, IDE/OS y generados de Java/Spring, Node/React/Angular, Python, n8n o Docker segun aplique.
- No debe ignorar specs incrementales, OpenAPI, migraciones ni documentacion versionable salvo instruccion explicita.

Cuando cambie la configuracion de LM Studio para un modelo usado por OpenCode:

1. Actualizar el default persistente en `.lmstudio/.internal/user-concrete-model-default-config/`.
2. Alinear el limite de contexto en `/home/cristiansrc/.config/opencode/opencode.json`.
3. Documentar el cambio en `resumen-configuracion-ia.txt`.
4. Si aplica a agentes, documentarlo en `agents/agentes-y-modelos.md`.

## Estado Actual y Pendientes

Pendiente por probar:

- Prueba de concepto de Delta Spec para una nueva funcionalidad.
- Validar Bug Fixing Workflow con un fallo real o simulado.
- Probar `requirements-analyst` con funcionalidad real o simulada.
- Confirmar que `requirements-brief.md` reduce ambiguedad antes del Planner.

Deuda tecnica:

- Implementar flujo n8n de AI Code Review externo para PRs.
- Publicar feedback automatico en GitHub desde n8n.

## Notas de Seguridad

- No hardcodear tokens en `opencode.json`.
- No guardar secretos en backups.
- Usar `/home/cristiansrc/.config/opencode/.env` para MCPs corporativos.
- El MCP de GitHub debe cargar el token desde `.env`.
- Antes de compartir esta carpeta, revisar backups y reportes historicos por informacion sensible.
