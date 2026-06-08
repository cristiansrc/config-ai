# Agentes y Modelos Gemini CLI

Ultima actualizacion: 2026-05-22

Fuente activa:
- Agentes: `/home/cristiansrc/Documentos/config-ai/gemini/agents/`
- Skills: `/home/cristiansrc/Documentos/config-ai/gemini/skills/`
- Backup: `/home/cristiansrc/Documentos/config-ai/gemini/backups/`

| Agente | Modelo | Editar | Bash | Descripcion |
|---|---|---:|---:|---|
| commander (DEFAULT) | opencode/deepseek-v4-flash-free | allow | allow | Agente principal para gestion del sistema operativo, terminal y tareas diarias. |
| architect-executor | opencode/deepseek-v4-flash-free | allow | allow | Arquitectura y ejecucion compleja. |
| context-curator | opencode/deepseek-v4-flash-free | deny | deny | Curacion de contexto eficiente. |
| documentation | opencode/deepseek-v4-flash-free | allow | deny | Generacion de documentacion. |
| executor | opencode/deepseek-v4-flash-free | allow | allow | Implementacion de codigo. |
| final-validation | opencode/deepseek-v4-flash-free | deny | allow | Validacion final de calidad. |
| planner | opencode/deepseek-v4-flash-free | allow | deny | Planificacion y specs SDD. |
| refactor | opencode/deepseek-v4-flash-free | allow | allow | Refactorizacion de codigo. |
| requirements-analyst | opencode/deepseek-v4-flash-free | allow | deny | Analisis de requerimientos iniciales. |
| reviewer | opencode/deepseek-v4-flash-free | deny | allow | Revision de codigo y calidad. |
| security-reviewer | opencode/deepseek-v4-flash-free | deny | allow | Auditoria de seguridad. |
| spec-remediator | opencode/deepseek-v4-flash-free | allow | deny | Correccion automatica de specs. |
| spec-validator | opencode/deepseek-v4-flash-free | allow | deny | Validacion de specs SDD. |
| task-decomposer | opencode/deepseek-v4-flash-free | allow | deny | Descomposicion de tareas. |
| test-architect | opencode/deepseek-v4-flash-free | allow | allow | Diseno de pruebas automatizadas. |
| functional-test-planner | opencode/deepseek-v4-flash-free | allow | deny | Analisis de specs y diseno de planes de pruebas funcionales. |
| functional-tester-agent | opencode/deepseek-v4-flash-free | allow | allow | Diseno, ejecucion y validacion de pruebas funcionales y UI/E2E en frontends. |
