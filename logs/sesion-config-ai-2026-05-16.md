# Sesion config-ai 2026-05-16

## Objetivo
Revisar y normalizar skills y agentes de OpenCode para dejar alineados los contratos, las convenciones de lenguaje y las reglas de arquitectura entre stacks.

## Hecho en esta sesion
- Se unifico la skill de validacion `spec-validation` y se elimino la variante duplicada `spect-validation`.
- Se tradujo `planner.md` a espanol operativo, manteniendo en ingles solo los tokens y convenciones canonicas.
- Se renombro la skill de errores REST de Java a `springboot-java-rest-error-response-standards`.
- Se crearon las variantes `springboot-kotlin-rest-error-response-standards` y `fastapi-rest-error-response-standards`.
- Se alinearon `openapi-standard`, `restful-standard` y `repository-dto-patterns` con las variantes por stack.
- Se ajustaron `python-stack` y `fastapi-stack` para usar `SQLAlchemy 2.x` + `Alembic` como persistencia por defecto y mappings explicitos.
- Se reescribio `design-patterns-standard` para evitar sobreingenieria y patrones obligatorios sin variabilidad real.
- Se reescribio `enterprise-architecture-standard` para enfocarla en arquitectura macro, bounded contexts y artefactos de contexto.
- Se reescribio `jpa-stack` para dejar JPA/Hibernate como infraestructura.
- Se reescribio `nodejs-stack` con reglas reales de TypeScript, validacion, persistencia y mapping.
- Se sincronizo `config-ai` varias veces con `sync-ai-configs.sh` para mantener el snapshot consistente.

## Estado actual
- `P1` de arquitectura y contratos esta completo.
- `python-stack`, `fastapi-stack` y `nodejs-stack` quedaron marcados como revisados en el backlog.
- El backlog activo ahora apunta a `spring-cloud-gateway` como siguiente skill pendiente.

## Falta por hacer
- Revisar `spring-cloud-gateway`.
- Continuar con las skills pendientes de `P3`:
  - `flyway-migrations`
  - `postgresql-standard`
  - `mysql-standard`
  - `oracle-standard`
  - `sqlserver-standard`
  - `rabbitmq-standard`
  - `kafka-standard`
  - `amazon-sqs-standard`
  - `n8n-stack`
- Revisar luego las skills de frontend, seguridad, documentacion y orquestacion.

## Referencias utiles
- Backlog activo: `active/opencode/skills-review-backlog.md`
- Resumen general: `resumen-configuracion-ia.txt`
