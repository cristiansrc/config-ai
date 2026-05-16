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
- [ ] spring-cloud-gateway

## Prioridad P3 - Datos, Mensajeria e Integraciones

- [ ] flyway-migrations
- [ ] postgresql-standard
- [ ] mysql-standard
- [ ] oracle-standard
- [ ] sqlserver-standard
- [ ] rabbitmq-standard
- [ ] kafka-standard
- [ ] amazon-sqs-standard
- [ ] n8n-stack

## Prioridad P4 - Frontend

- [ ] frontend-architecture
- [ ] react-stack
- [ ] angular-stack

## Prioridad P5 - Operacion, Seguridad y Documentacion

- [ ] security-standards
- [ ] keycloak-standard
- [ ] docker-standard
- [ ] observability-standard
- [ ] git-ops
- [ ] documentation-standards
- [ ] documentation-lifecycle

## Prioridad P6 - Orquestacion

- [ ] context-curation
- [ ] context-pinning
- [ ] model-tier-routing

## Proceso Por Skill

1. Leer skill activa y detectar duplicidad, contradicciones, reglas vagas y practicas obsoletas.
2. Proponer cambios concretos antes de editar cuando haya decisiones de criterio.
3. Aplicar cambios minimos sobre la skill activa.
4. Validar referencias cruzadas con skills relacionadas.
5. Ejecutar `sync-ai-configs.sh` para snapshot y sincronizacion.
6. Marcar la skill como revisada en este backlog.

## Siguiente Sugerencia

Continuar con `spring-cloud-gateway`, porque queda como el siguiente stack backend pendiente despues de cerrar `nodejs-stack`.
