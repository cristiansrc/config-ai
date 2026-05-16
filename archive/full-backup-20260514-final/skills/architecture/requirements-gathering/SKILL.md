---
name: requirements-gathering
description: Estándares y estructura para el levantamiento de requerimientos funcionales y técnicos.
---

# Levantamiento de Requerimientos (Requirements Gathering)

Guía para transformar una solicitud de usuario en un documento de requerimientos claro y accionable antes de la fase de planificación SDD.

## El Requirements Brief (`requirements-brief.md`)
Todo levantamiento debe producir un artefacto bajo `docs/specs/requirements/` o `docs/specs/.working/`.

### Estructura Mandatoria
1. **Status**: `requirements-discovery`.
2. **Objetivo**: Qué se busca lograr.
3. **Contexto**: Antecedentes y relación con el sistema actual.
4. **Actores y Permisos**: Quiénes interactúan y qué pueden hacer.
5. **Alcance (Scope)**: Lista detallada de funcionalidades.
6. **No Objetivos (Out of Scope)**: Qué no se hará para evitar el scope creep.
7. **Flujos de Usuario**: Secuencia de pasos principales.
8. **Entidades Funcionales**: Datos clave involucrados.
9. **Integraciones**: Sistemas externos o servicios necesarios.
10. **Seguridad y Restricciones**: Reglas críticas.
11. **Edge Cases**: Escenarios no comunes.
12. **Criterios de Aceptación**: Cómo saber que se cumplió el requerimiento.
13. **Preguntas Abiertas**: Dudas para el Usuario/Planner.
14. **Handoff para Planner**: Resumen técnico para la fase SDD.

## Reglas de Proceso
- **Claridad sobre Solución**: El enfoque es funcional; no debe definir contratos OpenAPI ni esquemas de base de datos finales (esto es labor del Planner).
- **Reducción de Ambigüedad**: Si un término es vago, se debe preguntar al usuario antes de cerrar el brief.
- **Estado de Bloqueo**: No se puede pasar a la fase `planner` si hay preguntas críticas abiertas en el brief.
