# Sesion config-ai 2026-05-16

## Objetivo
Revisar y normalizar skills y agentes de OpenCode para dejar alineados los contratos, las convenciones de lenguaje y las reglas de arquitectura entre stacks.

## Hecho en esta sesion
- Se unifico la skill de validacion `spec-validation` y se elimino la variante duplicada `spect-validation`.
- Se traducio `planner.md` a espanol operativo, manteniendo en ingles solo los tokens y convenciones canonicas.
- Se renombro la skill de errores REST de Java a `springboot-java-rest-error-response-standards`.
- Se crearon las variantes `springboot-kotlin-rest-error-response-standards` y `fastapi-rest-error-response-standards`.
- Se alinearon `openapi-standard`, `restful-standard` y `repository-dto-patterns` con las variantes por stack.
- Se ajustaron `python-stack` y `fastapi-stack` para usar `SQLAlchemy 2.x` + `Alembic` como persistencia por defecto y mappings explicitos.
- Se reescribio `design-patterns-standard` para evitar sobreingenieria y patrones obligatorios sin variabilidad real.
- Se reescribio `enterprise-architecture-standard` para enfocarla en arquitectura macro, bounded contexts y artefactos de contexto.
- Se reescribio `jpa-stack` para dejar JPA/Hibernate como infraestructura.
- Se reescribio `nodejs-stack` con reglas reales de TypeScript, validacion, persistencia y mapping.
- Se sincronizo `config-ai` varias veces con `sync-ai-configs.sh` para mantener el snapshot consistente.

### Revision de Skills Pendientes (Segunda Parte de la Sesion)

Se revisaron y mejoraron 23 skills aplicando consistentemente:
- Criterios de Deteccion del Stack
- Prohibiciones explicitas
- Comportamiento Obligatorio
- Auditory y Soft Delete alineados con jpa-stack en todas las skills de BD
- Seccion de Pruebas donde aplica
- Referencias cruzadas entre skills
- Alineacion de trace_id como header X-Trace-Id y campo JSON trace_id

**P2 - Backend Stack:**
- spring-cloud-gateway: Anadida deteccion, prohibiciones, filtro ordering, testing, WebFlux restrictions, comportamiento obligatorio.

**P3 - Datos, Mensajeria e Integraciones:**
- flyway-migrations: Anadida deteccion, baseline, conflictos de version, separacion DDL/DML, comportamiento obligatorio, prohibicion de ddl-auto=create/update.
- postgresql-standard: Anadida deteccion, auditoria y soft delete, prohibiciones, tipos de datos (TIMESTAMPTZ, MONEY prohibido).
- mysql-standard: Anadida deteccion, auditoria y soft delete, prohibiciones (MyISAM, utf8 charset), naming de constraints.
- oracle-standard: Anadida deteccion, auditoria y soft delete, prohibiciones (LONG, VARCHAR2 BYTE, DATE), paginacion OFFSET/FETCH.
- sqlserver-standard: Anadida deteccion, auditoria y soft delete, prohibiciones (MONEY, DATETIME, dbo schema), naming consistente snake_case.
- rabbitmq-standard: Anadida deteccion, arquitectura hexagonal, naming convention, serializacion, trazabilidad, pruebas, prohibiciones.
- kafka-standard: Anadida deteccion, arquitectura hexagonal, producer/consumer config, Schema Registry obligatorio, DLT, pruebas, prohibiciones.
- amazon-sqs-standard: Anadida deteccion, arquitectura hexagonal, FIFO naming, batch, estructura del mensaje, pruebas, prohibiciones.
- n8n-stack: Anadido frontmatter, estructura de archivos, naming conventions, GitOps, seguridad, manejo de errores, observabilidad, pruebas, prohibiciones.

**P4 - Frontend:**
- frontend-architecture: Reescrita como skill transversal con FSD, type safety, gestion de estado, API clients, testing, auth, prohibiciones.
- react-stack: Anadido frontmatter, FSD, gestions de estado, React 19, type safety, API/errors, pruebas, comportamiento obligatorio, prohibiciones.
- angular-stack: Anadido frontmatter, standalone components, Signals, Zoneless, DI, API/errors, pruebas, comportamiento obligatorio, prohibiciones.

**P5 - Operacion, Seguridad y Documentacion:**
- security-standards: Anadida deteccion, validacion de tokens, proteccion de datos, OWASP, checklist, prohibiciones.
- keycloak-standard: Anadida deteccion, configuracion como codigo, observabilidad, pruebas, prohibiciones.
- docker-standard: Anadido frontmatter, deteccion, multi-stage, health checks, .dockerignore, image tagging, resource limits, prohibiciones.
- observability-standard: Anadido frontmatter, deteccion, instrumentacion por stack, prohibiciones.
- git-ops: Mejorada con deteccion, prohibit commit directo en main, pnpm obligatorio, prohibiciones.
- documentation-standards: Anadida deteccion, README template, ADRs, Mermaid, comportamiento obligatorio, prohibiciones.
- documentation-lifecycle: Anadida deteccion, sincronizacion con migraciones, trazabilidad, prohibiciones.

**P6 - Orquestacion:**
- context-curation: Anadida deteccion, exclusiones, regla de economia, skills relevantes por dominio, prohibiciones.
- context-pinning: Anadida deteccion, rehidratacion tras compaction, prohibiciones.
- model-tier-routing: Eliminada referencia a modelos lmstudio hardcodeados, ahora referencia a agentes-y-modelos.md como fuente de verdad, escala de complejidad, prohibiciones.

## Estado actual
- **Todas las 47 skills revisadas** y marcadas en el backlog.
- **Agente duplicado `spec-validation` eliminado** (era alias obsoleto redirigido a `spec-validator`).
- **18 agentes simplificados**: eliminadas reglas tecnicas duplicadas en skills, anadida seccion "Skills de Referencia", unificado idioma.
- Principio aplicado: Agentes definen QUE y RESPONSABILIDAD; Skills definen COMO.
- Snapshot sincronizado con `sync-ai-configs.sh`.

## Falta por hacer
- Validacion cruzada final entre agentes y skills para verificar consistencia de terminologia y referencias.
- Probar `requirements-analyst` con una funcionalidad real.
- Probar el Bug Fixing Workflow con un fallo real/simulado.

## Referencias utiles
- Backlog activo: `active/opencode/skills-review-backlog.md`
- Resumen general: `resumen-configuracion-ia.txt`