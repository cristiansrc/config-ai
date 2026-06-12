# Skills Review Backlog

Ultima actualizacion: 2026-05-16

Objetivo: revisar las 47 skills activas de OpenCode una por una, mejorar mejores practicas, separar responsabilidades, eliminar contradicciones y reforzar reglas operativas para que los agentes produzcan artefactos mas consistentes.

## Criterios de Revision

- Responsabilidad unica: cada skill debe cubrir un tema claro y no duplicar reglas que pertenecen a otra skill.
- Mejores practicas actuales: actualizar convenciones de stack, seguridad, testing, observabilidad y despliegue.
- Reglas accionables: preferir instrucciones verificables por agentes sobre recomendaciones vagas.
- Compatibilidad entre skills: evitar contradicciones entre framework, lenguaje, arquitectura, calidad y seguridad.
- Fuente de verdad: declarar rutas canonicas, artefactos esperados y condiciones de activacion.
- Guardrails: incluir prohibiciones claras para decisiones peligrosas, secretos, placeholders, deuda tecnica falsa o mappings inconsistentes.
- Minimalismo: no inflar las skills con teoria; mantenerlas utiles para ejecucion real.

## Prioridad P0 - Flujo SDD y Calidad Central

- [x] spec-driven-development
- [x] spec-remediation
- [x] requirements-gathering
- [x] pre-flight-check
- [x] testing-strategy
- [x] code-review-checklist
- [x] bug-fixing-workflow

## Prioridad P1 - Arquitectura y Contratos

- [x] hexagonal-architecture
- [x] openapi-first
- [x] openapi-standard
- [x] restful-standard
- [x] springboot-java-rest-error-response-standards
- [x] springboot-kotlin-rest-error-response-standards
- [x] fastapi-rest-error-response-standards
- [x] repository-dto-patterns
- [x] design-patterns-standard
- [x] enterprise-architecture-standard

## Prioridad P2 - Stacks Backend y Lenguajes

- [x] springboot-stack
- [x] java-stack
- [x] kotlin-stack
- [x] jpa-stack
- [x] python-stack
- [x] fastapi-stack
- [x] nodejs-stack
- [x] spring-cloud-gateway

## Prioridad P3 - Datos, Mensajeria e Integraciones

- [x] flyway-migrations
- [x] postgresql-standard
- [x] mysql-standard
- [x] oracle-standard
- [x] sqlserver-standard
- [x] rabbitmq-standard
- [x] kafka-standard
- [x] amazon-sqs-standard
- [x] n8n-stack

## Prioridad P4 - Frontend

- [x] frontend-architecture
- [x] react-stack
- [x] angular-stack

## Prioridad P5 - Operacion, Seguridad y Documentacion

- [x] security-standards
- [x] keycloak-standard
- [x] docker-standard
- [x] observability-standard
- [x] git-ops
- [x] documentation-standards
- [x] documentation-lifecycle

## Prioridad P6 - Orquestacion

- [x] context-curation
- [x] context-pinning
- [x] model-tier-routing

## Prioridad P7 - Asistentes Personales (HyprMind)

- [x] hyprmind-delegation-protocol
- [x] hyprmind-memory-manager
- [x] hyprmind-workspace-manager

## Proceso Por Skill

1. Leer skill activa y detectar duplicidad, contradicciones, reglas vagas y practicas obsoletas.
2. Proponer cambios concretos antes de editar cuando haya decisiones de criterio.
3. Aplicar cambios minimos sobre la skill activa.
4. Validar referencias cruzadas con skills relacionadas.
5. Ejecutar `sync-ai-configs.sh` para snapshot y sincronizacion.
6. Marcar la skill como revisada en este backlog.

## Siguiente Sugerencia

Todas las skills (47) han sido revisadas. Próximo paso: validación cruzada final y sincronización con `sync-ai-configs.sh`.
