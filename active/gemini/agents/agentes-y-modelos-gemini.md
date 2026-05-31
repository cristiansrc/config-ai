# Agentes y Modelos Gemini CLI

Ultima actualizacion: 2026-05-22

Fuente activa:
- Agentes: `/home/cristiansrc/Documentos/config-ai/gemini/agents/`
- Skills: `/home/cristiansrc/Documentos/config-ai/gemini/skills/`
- Backup: `/home/cristiansrc/Documentos/config-ai/gemini/backups/`

| Agente | Modelo | Editar | Bash | Descripcion |
|---|---|---:|---:|---|
| commander (DEFAULT) | gemini-3-flash-lite-preview | allow | allow | Agente principal para gestion del sistema operativo, terminal y tareas diarias. |
| architect-executor | gemini-3-pro-preview | allow | allow | Arquitectura y ejecucion compleja. |
| context-curator | gemini-2.5-flash-lite | deny | deny | Curacion de contexto eficiente. |
| documentation | gemini-2.5-flash-lite | allow | deny | Generacion de documentacion. |
| executor | gemini-3-flash-preview | allow | allow | Implementacion de codigo. |
| final-validation | gemini-3-pro-preview | deny | allow | Validacion final de calidad. |
| planner | gemini-3-pro-preview | allow | deny | Planificacion y specs SDD. |
| refactor | gemini-3-pro-preview | allow | allow | Refactorizacion de codigo. |
| requirements-analyst | gemini-3-pro-preview | allow | deny | Analisis de requerimientos iniciales. |
| reviewer | gemini-3-flash-preview | deny | allow | Revision de codigo y calidad. |
| security-reviewer | gemini-3-flash-preview | deny | allow | Auditoria de seguridad. |
| spec-remediator | gemini-3-flash-preview | allow | deny | Correccion automatica de specs. |
| spec-validator | gemini-3-pro-preview | allow | deny | Validacion de specs SDD. |
| task-decomposer | gemini-3-flash-preview | allow | deny | Descomposicion de tareas. |
| test-architect | gemini-3-pro-preview | allow | allow | Diseno de pruebas automatizadas. |
| functional-test-planner | gemini-3-pro-preview | allow | deny | Analisis de specs y diseno de planes de pruebas funcionales. |
| functional-tester-agent | gemini-3-pro-preview | allow | allow | Diseno, ejecucion y validacion de pruebas funcionales y UI/E2E en frontends. |
