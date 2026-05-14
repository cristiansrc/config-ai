# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-05-14

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.json`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/agents/backup-20260512-165346/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/skill/backup-20260514/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Idioma obligatorio: Todas las respuestas e interacciones de los agentes con el usuario deben ser en ESPAÑOL.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.
- Cambio operativo vigente (temporal): Spec Remediator debe invocar validaciones solo mediante `spec-validator` con `opencode-go/deepseek-v4-pro`; cualquier validacion ejecutada con otro modelo debe bloquearse como `Blocked: wrong validator model`.

Perfil LM Studio persistente:
- `lmstudio/qwen/qwen3.6-35b-a3b`: context length `152563`, GPU offload ratio `26/64` capas, K/V cache `Q4_0`. OpenCode declara el mismo limite de contexto para que no intente usar el valor anterior.

| Agente                | Modelo                        | Editar            | Bash  | Descripcion                                                                                                                               |
|-----------------------|-------------------------------|-------------------|-------|-------------------------------------------------------------------------------------------------------------------------------------------|
| architect-executor    | opencode-go/deepseek-v4-pro   | allow             | allow | Implementa tareas complejas que requieren razonamiento arquitectonico local sin reemplazar al Planner.                                    |
| devops-architect      | opencode-go/qwen3.5-plus      | allow             | allow | Especialista en Infraestructura como Código, Docker, CI/CD y Observabilidad.                                                              |
| context-curator       | opencode-go/deepseek-v4-flash | deny              | deny  | Selecciona y resume contexto relevante para otros agentes, reduciendo ruido.                                                              |
| documentation         | opencode-go/minimax-m2.7      | allow             | deny  | Crea y actualiza documentacion operativa, README, notas de despliegue y docs funcionales.                                                 |
| executor              | opencode-go/deepseek-v4-flash | allow             | allow | Implementa codigo desde specs aprobadas y task boards validados siguiendo patrones del repo.                                              |
| final-validation      | opencode-go/qwen3.6-plus      | deny              | allow | Hace validacion final de produccion: specs, implementacion, tests, seguridad y documentacion.                                             |
| planner               | opencode-go/qwen3.6-plus      | allow             | deny  | Produce specs SDD, decisiones de arquitectura, contratos OpenAPI y restricciones tecnicas.                                                |
| refactor              | opencode-go/qwen3.5-plus      | allow             | allow | Refactoriza codigo ya implementado sin cambiar comportamiento externo.                                                                    |
| requirements-analyst  | opencode-go/qwen3.6-plus      | allow             | deny  | Levanta requerimientos antes del Planner y produce `requirements-brief.md` con alcance, actores, flujos, riesgos y preguntas abiertas.    |
| reviewer              | opencode-go/qwen3.5-plus      | deny              | allow | Revisa codigo generado para detectar bugs, drift arquitectonico, deuda y falta de tests.                                                  |
| security-reviewer     | opencode-go/deepseek-v4-pro   | deny              | allow | Revisa riesgos OWASP, auth/authz, manejo de secretos y arquitectura segura.                                                               |
| spec-remediator       | opencode-go/deepseek-v4-flash | allow             | deny  | Corrige hallazgos mecanicos o drift SDD seguro, uno por uno, sin decidir arquitectura.                                                    |
| spec-validator        | opencode-go/deepseek-v4-pro   | allow limitado    | deny  | Valida specs SDD y coherencia contra OpenAPI, migraciones, config, task board y shared context.                                           |
| task-decomposer       | opencode-go/qwen3.5-plus      | allow             | deny  | Descompone specs validadas en tareas atomicas ejecutables con dependencias y verificacion.                                                |
| test-architect        | opencode-go/qwen3.5-plus      | allow             | allow | Disena y genera pruebas automatizadas, edge cases, integracion y estrategia de validacion.                                                |
