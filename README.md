# config-ai

Repositorio local de referencia para la configuración de IA usada con OpenCode, LM Studio, agentes especializados, skills SDD y respaldos operativos.

Última actualización documentada: 2026-05-14.

## Objetivo

Esta carpeta consolida el estado canónico del entorno de IA local:

- **OpenCode** como orquestador de agentes senior.
- **Jerarquía Arquitectónica**: Niveles Enterprise (Macro), Solution (Meso) y Project (Micro).
- **Solution Workspace**: Gestión multi-repo bajo un contexto global.
- **SDD Incremental**: Ciclo de vida basado en especificaciones y validación estricta.
- **Ecosistema Senior**: 34 habilidades alineadas con estándares de industria 2026.

## Estructura de Respaldo

```text
config-ai/
|-- README.md
|-- resumen-configuracion-ia.txt
|-- agents/
|   `-- agentes-y-modelos.md
|-- backups/
|   `-- full-backup-20260514-final/ <-- (Estado actual consolidado)
`-- opencode/
    `-- opencode.json (Referencia operativa)
```

## Agentes y Responsabilidades

| Agente | Nivel | Misión Operativa | Skill de Referencia |
|---|---|---|---|
| **enterprise-architect** | Macro | Diseña el System Landscape y fronteras DDD. | `enterprise-architecture-standard` |
| **solution-architect** | Meso | Selecciona patrones GoF y estructura local. | `design-patterns-standard` |
| **planner** | Micro | Planifica incrementos SDD y diseña contratos API. | `spec-driven-development` |
| **requirements-analyst** | Pre-SDD | Levanta requerimientos y reduce ambigüedad. | `requirements-gathering` |
| **spec-validator** | Gate | Valida consistencia y otorga veredicto 'ready'. | `spec-driven-development` |
| **spec-remediator** | Fix | Corrige hallazgos de validación iterativamente. | `spec-remediation` |
| **task-decomposer** | Prep | Atomiza especificaciones en tareas atómicas. | `spec-driven-development` |
| **executor** | Dev | Implementa código verificado y pre-flight checks. | `springboot-stack` / `fastapi-stack` |
| **reviewer** | Audit | Detecta bugs, drift y deuda técnica. | `code-review-checklist` |
| **security-reviewer** | Cyber | Valida postura de seguridad y cumplimiento. | `security-standards` |
| **final-validation** | QA | Garantiza calidad final y cobertura del 85%. | `testing-strategy` |
| **devops-architect** | Ops | Gestiona IaC, Docker y CI/CD. | `docker-standard` |
| **context-curator** | Info | Optimiza la ventana de contexto y reduce ruido. | `context-curation` |

## Ecosistema de Skills (34 Skills Activas)

Nuestras skills definen el "Cómo" de cada tarea técnica:

### 🏗️ Arquitectura y Diseño
1. `hexagonal-architecture`: Puertos y Adaptadores (Clean Architecture).
2. `openapi-first`: Diseño basado en contratos (Single Source of Truth).
3. `spec-driven-development`: Ciclo de vida incremental y Gates de validación.
4. `restful-standard`: Estándares REST (snake_case, pluralización, kebab-case).
5. `enterprise-architecture-standard`: Visión Macro, Modelo C4 y Solution Workspace.
6. `design-patterns-standard`: Patrones GoF aplicados a stacks modernos.
7. `requirements-gathering`: Estructura de Requirements Brief y descubrimiento.
8. `spec-remediation`: Proceso de corrección granular de hallazgos.

### 🔙 Stacks y Frameworks
9. `springboot-stack`: Convenciones Spring Boot 2026 y Virtual Threads.
10. `fastapi-stack`: Alto rendimiento con Python y Pydantic V2.
11. `jpa-stack`: Persistencia senior, Auditoría y Soft Delete nativo.
12. `python-stack`: Estándares de lenguaje (uv, ruff, mypy).
13. `nodejs-stack`: Clean Architecture para Node.js y Zod.
14. `spring-cloud-gateway`: Resiliencia, Token Relay y seguridad de borde.
15. `react-stack`: Convenciones React 19 y Feature Sliced Design.
16. `angular-stack`: Standalone Components y Signals.

### 🗄️ Gestión de Datos
17. `flyway-migrations`: Evolución de esquemas multi-motor (Postgres, MySQL, Oracle, SQL).
18. `postgresql-standard`: Optimización, JSONB y Triggers de Auditoría.
19. `mysql-standard`: InnoDB y soporte Unicode completo.
20. `oracle-standard`: Convenciones Identity y VARCHAR2 CHAR.
21. `sqlserver-standard`: PascalCase y tipos de datos T-SQL senior.
22. `repository-dto-patterns`: Desacoplamiento de persistencia y transporte.

### ✅ Calidad, Seguridad y Ops
23. `testing-strategy`: Umbral del 85% de cobertura mandatorio.
24. `bug-fixing-workflow`: Protocolo de reproducción empírica.
25. `pre-flight-check`: Validación técnica previa a commits.
26. `security-standards`: OWASP, JWT y protección de secretos.
27. `keycloak-standard`: Gestión de identidad y flujos OIDC/PKCE.
28. `git-ops`: Automatización de ramas y commits semánticos.
29. `observability-standard`: Logs JSON, OpenTelemetry y trazas.
30. `docker-standard`: Empaquetamiento seguro y multi-stage.

### 📖 Documentación y Orquestación
31. `documentation-lifecycle`: Consolidación automática en Master Spec.
32. `documentation-standards`: Estándares de README y diagramas.
33. `context-pinning`: Protección de archivos críticos y Master Spec.
34. `context-curation`: Estrategias de filtrado de información.

## Políticas Globales Mandatorias

1. **Auditoría Permanente**: Campos `created_at`, `updated_at` y `deleted` en toda tabla de negocio.
2. **Borrado Lógico**: Prohibida la eliminación física (Soft Delete gestionado por `jpa-stack`/FastAPI).
3. **Calidad Bloqueante**: Mínimo 85% de cobertura en archivos testables.
4. **Naming Universal**: `snake_case` en BBDD, Atributos JSON y variables.
5. **Idioma**: Interacción con el usuario exclusivamente en **Español**.

---
*Fábrica de Software Senior - Configuración 2026*
