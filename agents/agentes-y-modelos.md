# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-05-11

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.json`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/agents/backup-20260511-120114/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/skill/backup-20260511-120114/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.

| Agente | Modelo | Editar | Bash | Descripcion |
|---|---|---:|---:|---|
| architect-executor | lmstudio/Jackrong/qwopus3.5-27b-v3.5 | allow | allow | Implementa tareas complejas que requieren razonamiento arquitectonico local sin reemplazar al Planner. |
| context-curator | lmstudio/google/gemma-4-e4b | deny | deny | Selecciona y resume contexto relevante para otros agentes, reduciendo ruido. |
| documentation | lmstudio/google/gemma-4-e2b | allow | deny | Crea y actualiza documentacion operativa, README, notas de despliegue y docs funcionales. |
| executor | lmstudio/openai/gpt-oss-20b | allow | allow | Implementa codigo desde specs aprobadas y task boards validados siguiendo patrones del repo. |
| final-validation | openai/gpt-5.5 | deny | allow | Hace validacion final de produccion: specs, implementacion, tests, seguridad y documentacion. |
| planner | lmstudio/qwen/qwen3.6-35b-a3b | allow | deny | Produce specs SDD, decisiones de arquitectura, contratos OpenAPI y restricciones tecnicas. |
| refactor | lmstudio/qwopus3.5-27b-v3.5 | allow | allow | Refactoriza codigo ya implementado sin cambiar comportamiento externo. |
| requirements-analyst | lmstudio/qwen/qwen3.6-35b-a3b | allow | deny | Levanta requerimientos antes del Planner y produce `requirements-brief.md` con alcance, actores, flujos, riesgos y preguntas abiertas. |
| reviewer | lmstudio/google/gemma-4-26b-a4b | deny | allow | Revisa codigo generado para detectar bugs, drift arquitectonico, deuda y falta de tests. |
| security-reviewer | lmstudio/qwopus3.5-27b-v3.5 | deny | allow | Revisa riesgos OWASP, auth/authz, manejo de secretos y arquitectura segura. |
| spec-remediator | lmstudio/qwopus3.5-27b-v3.5 | allow | deny | Corrige hallazgos mecanicos o drift SDD seguro, uno por uno, sin decidir arquitectura. |
| spec-validator | openai/gpt-5.5 | allow limitado | deny | Valida specs SDD y coherencia contra OpenAPI, migraciones, config, task board y shared context. |
| task-decomposer | lmstudio/qwopus3.5-27b-v3.5 | allow | deny | Descompone specs validadas en tareas atomicas ejecutables con dependencias y verificacion. |
| test-architect | lmstudio/qwopus3.5-27b-v3.5 | allow | allow | Disena y genera pruebas automatizadas, edge cases, integracion y estrategia de validacion. |
