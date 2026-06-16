# Agentes y Modelos Gemini CLI

Ultima actualizacion: 2026-05-22

Fuente activa:
- Agentes: `/home/cristiansrc/Documentos/config-ai/gemini/agents/`
- Skills: `/home/cristiansrc/Documentos/config-ai/gemini/skills/`
- Backup: `/home/cristiansrc/Documentos/config-ai/gemini/backups/`

| Agente | Modelo | Editar | Bash | Descripcion |
|---|---|---:|---:|---|
| commander (DEFAULT) | opencode-go/deepseek-v4-flash | allow | allow | Agente principal para gestion del sistema operativo, terminal y tareas diarias. |
| architect-executor | opencode-go/deepseek-v4-flash | allow | allow | Arquitectura y ejecucion compleja. |
| context-curator | opencode-go/deepseek-v4-flash | deny | deny | Curacion de contexto eficiente. |
| documentation | opencode-go/deepseek-v4-flash | allow | deny | Generacion de documentacion. |
| executor | opencode-go/deepseek-v4-flash | allow | allow | Implementacion de codigo. |
| final-validation | opencode-go/deepseek-v4-flash | deny | allow | Validacion final de calidad. |
| planner | opencode-go/deepseek-v4-flash | allow | deny | Planificacion y specs SDD. |
| refactor | opencode-go/deepseek-v4-flash | allow | allow | Refactorizacion de codigo. |
| requirements-analyst | opencode-go/deepseek-v4-flash | allow | deny | Analisis de requerimientos iniciales. |
| reviewer | opencode-go/deepseek-v4-flash | deny | allow | Revision de codigo y calidad. |
| security-reviewer | opencode-go/deepseek-v4-flash | deny | allow | Auditoria de seguridad. |
| spec-remediator | opencode-go/deepseek-v4-flash | allow | deny | Correccion automatica de specs. |
| spec-validator | opencode-go/deepseek-v4-flash | allow | deny | Validacion de specs SDD. |
| task-decomposer | opencode-go/deepseek-v4-flash | allow | deny | Descomposicion de tareas. |
| test-architect | opencode-go/deepseek-v4-flash | allow | allow | Diseno de pruebas automatizadas. |
| functional-test-planner | opencode-go/deepseek-v4-flash | allow | deny | Analisis de specs y diseno de planes de pruebas funcionales. |
| functional-tester-agent | opencode-go/deepseek-v4-flash | allow | allow | Diseno, ejecucion y validacion de pruebas funcionales y UI/E2E en frontends. |
