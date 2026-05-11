---
name: model-tier-routing
description: Política de escalamiento de modelos basada en la complejidad de la tarea para optimizar performance, costo y calidad del razonamiento.
---

# Model Tier Routing Skill

Esta skill define qué modelo debe usar OpenCode según el nivel de dificultad de la tarea.

Regla base:
- El modelo por defecto global de OpenCode debe ser `lmstudio/google/gemma-4-e4b`.
- Los agentes especializados deben usar los modelos declarados en `/home/cristiansrc/.config/opencode/agents/*.md`; esa configuracion es la fuente de verdad operativa.
- Usa `lmstudio/google/gemma-4-e4b` para curacion de contexto, tareas ligeras o bajo riesgo.
- Usa `lmstudio/google/gemma-4-e2b` para documentacion simple y operacional.
- Usa `lmstudio/openai/gpt-oss-20b` para ejecucion rapida de tareas implementables con specs ya aprobadas.
- Usa `lmstudio/qwopus3.5-27b-v3.5` o `lmstudio/Jackrong/qwopus3.5-27b-v3.5` para implementacion compleja, refactor, seguridad, tests y remediacion de specs.
- Usa `lmstudio/qwen/qwen3.6-35b-a3b` para levantamiento de requerimientos, planificacion SDD, contratos y decisiones de arquitectura.
- Usa `openai/gpt-5.5` solo para validaciones criticas: `spec-validator` y `final-validation`, salvo autorizacion explicita para escalar otro agente.

## Escala 1: Baja Complejidad (Gemma 4 E4B/E2B en LM Studio)
**Uso:** Mecanografía, tareas atómicas con specs 100% claras.
- Generación de boilerplate (getters/setters, constructors).
- Implementación de DTOs y Mappers simples.
- Tareas de documentación técnica básica.
- Corrección de errores de sintaxis simples.

## Escala 2: Ejecucion Rapida (GPT-OSS 20B en LM Studio)
**Uso:** Implementacion mecanica desde specs y task boards validados.
- Cambios de codigo con alcance claro.
- Actualizacion de task board durante ejecucion.
- Verificacion con tests/comandos relevantes.

## Escala 3: Complejidad Media/Alta (Qwopus 27B en LM Studio)
**Uso:** Implementación lógica, razonamiento arquitectónico local.
- Desarrollo de Casos de Uso (Application layer).
- Implementación de Adapters de persistencia o web.
- Refactorización de métodos y clases pequeñas.
- Escritura de Unit Tests.
- Seguridad, refactor, test strategy y correcciones mecanicas de drift SDD.

## Escala 4: Alta Complejidad / Requerimientos / Diseño (Qwen 35B en LM Studio)
**Uso:** Requirements Analyst, Planificación, Arquitectura y SDD.
- Creación de `requirements-brief.md`.
- Creación de Specs Técnicas (Planner).
- Diseño de Contratos OpenAPI complejos.
- Definición de Modelos de Datos y transaccionalidad.
- Análisis de impacto en sistemas distribuidos.

## Escala 5: Crítica / Validación (OpenAI GPT-5.5)
**Uso:** Seguridad, Auditoría y Verificación Final.
- Validación final de Specs críticas (Spec Validator).
- Validación final de producción (Final Validation).
- Resolución de problemas de alta concurrencia o race conditions.
- Auditoría de código sensible (Auth/Payment).

**Regla Dinámica:** Si un modelo de nivel inferior falla en resolver una tarea tras 2 intentos, el agente debe recomendar escalar al siguiente nivel de la pirámide. No cambiar modelos en archivos de agentes sin actualizar tambien el resumen de configuracion.
