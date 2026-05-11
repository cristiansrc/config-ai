# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-05-11

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.json`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/agents/backup-20260511-140434/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/skill/backup-20260511-130320/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.

Perfil LM Studio persistente:
- `lmstudio/qwen3.6-27b`: context length `145858`, GPU offload ratio `1.0` equivalente a `64/64` capas, CPU thread pool size `6`, K/V cache `q4_0`, flash attention activo. OpenCode declara el mismo limite de contexto para que no intente usar el valor anterior.

| Agente | Modelo | Editar | Bash | Descripcion |
|---|---|---:|---:|---|
| architect-executor | lmstudio/qwen3.6-27b | allow | allow | Implementa tareas complejas que requieren razonamiento arquitectonico local sin reemplazar al Planner. |
| context-curator | lmstudio/qwen3.5-9b-claude-4.6-opus-reasoning-distilled-v2 | deny | deny | Selecciona y resume contexto relevante para otros agentes, reduciendo ruido. |
| documentation | lmstudio/google/gemma-4-e2b | allow | deny | Crea y actualiza documentacion operativa, README, notas de despliegue y docs funcionales. |
| executor | lmstudio/qwen3.5-9b-claude-4.6-opus-reasoning-distilled-v2 | allow | allow | Implementa codigo desde specs aprobadas y task boards validados siguiendo patrones del repo. |
| final-validation | openai/gpt-5.5 | deny | allow | Hace validacion final de produccion: specs, implementacion, tests, seguridad y documentacion. |
| planner | lmstudio/qwen/qwen3.6-35b-a3b | allow | deny | Produce specs SDD, decisiones de arquitectura, contratos OpenAPI y restricciones tecnicas. |
| refactor | lmstudio/qwen3.6-27b | allow | allow | Refactoriza codigo ya implementado sin cambiar comportamiento externo. |
| requirements-analyst | lmstudio/qwen/qwen3.6-35b-a3b | allow | deny | Levanta requerimientos antes del Planner y produce `requirements-brief.md` con alcance, actores, flujos, riesgos y preguntas abiertas. |
| reviewer | lmstudio/google/gemma-4-26b-a4b | deny | allow | Revisa codigo generado para detectar bugs, drift arquitectonico, deuda y falta de tests. |
| security-reviewer | lmstudio/qwen3.6-27b | deny | allow | Revisa riesgos OWASP, auth/authz, manejo de secretos y arquitectura segura. |
| spec-remediator | lmstudio/qwen3.6-27b | allow | deny | Corrige hallazgos mecanicos o drift SDD seguro, uno por uno, sin decidir arquitectura. |
| spec-validator | openai/gpt-5.5 | allow limitado | deny | Valida specs SDD y coherencia contra OpenAPI, migraciones, config, task board y shared context. |
| task-decomposer | lmstudio/qwen3.6-27b | allow | deny | Descompone specs validadas en tareas atomicas ejecutables con dependencias y verificacion. |
| test-architect | lmstudio/qwen3.6-27b | allow | allow | Disena y genera pruebas automatizadas, edge cases, integracion y estrategia de validacion. |
