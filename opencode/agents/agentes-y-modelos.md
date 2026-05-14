# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-05-14

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.json`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/backups/full-backup-20260514-final/agents/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/backups/full-backup-20260514-final/skills/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Idioma obligatorio: Todas las respuestas e interacciones de los agentes con el usuario deben ser en ESPAÑOL.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.
- Cambio operativo vigente (temporal): Spec Remediator debe invocar validaciones solo mediante `spec-validator` con `opencode-go/deepseek-v4-pro`; cualquier validacion ejecutada con otro modelo debe bloquearse como `Blocked: wrong validator model`.

Perfil LM Studio persistente:
- `lmstudio/qwen/qwen3.6-35b-a3b`: context length `152563`, GPU offload ratio `26/64` capas, K/V cache `Q4_0`. OpenCode declara el mismo limite de contexto para que no intente usar el valor anterior.

| Agente                | Modelo                        | Editar            | Bash  | Descripcion                                                                                                                               |
|-----------------------|-------------------------------|-------------------|-------|-------------------------------------------------------------------------------------------------------------------------------------------|
| architect-executor    | opencode-go/deepseek-v4-pro   | allow             | allow | Implementa tareas de arquitectura local y lógica compleja siguiendo `hexagonal-architecture`.                                              |
| devops-architect      | opencode-go/qwen3.5-plus      | allow             | allow | Especialista en Infraestructura como Código y CI/CD siguiendo `docker-standard` y `observability-standard`.                                |
| context-curator       | opencode-go/deepseek-v4-flash | deny              | deny  | Gestiona la ventana de contexto y reduce ruido siguiendo `context-curation` y `context-pinning`.                                          |
| documentation         | opencode-go/minimax-m2.7      | allow             | deny  | Gestiona el ciclo de vida de la documentación siguiendo `documentation-lifecycle` y `documentation-standards`.                            |
| executor              | opencode-go/deepseek-v4-flash | allow             | allow | Implementa código verificado siguiendo los estándares del stack correspondiente (`springboot-stack`, `fastapi-stack`, etc.).              |
| final-validation      | opencode-go/qwen3.6-plus      | deny              | allow | Garantiza la calidad final y cobertura mínima siguiendo `testing-strategy` y `pre-flight-check`.                                          |
| enterprise-architect  | opencode-go/qwen3.6-plus      | allow             | deny  | Define el System Landscape, fronteras de microservicios y flujos globales siguiendo `enterprise-architecture-standard`. |
| solution-architect    | opencode-go/qwen3.6-plus      | allow             | deny  | Elige patrones de diseño siguiendo `design-patterns-standard`. Colabora con `enterprise-architect` para alinear el diseño local con el global. |
| planner               | opencode-go/qwen3.6-plus      | allow             | deny  | Planifica incrementos SDD y diseña contratos. Consulta a `solution-architect` para decisiones de patrones complejos.      |
| refactor              | opencode-go/qwen3.5-plus      | allow             | allow | Refactoriza código existente siguiendo `refactor-patterns` y `refactor-hexagonal-bridge`.                                                 |
| requirements-analyst  | opencode-go/qwen3.6-plus      | allow             | deny  | Realiza el levantamiento de requerimientos funcionales siguiendo `requirements-gathering`.                                                |
| reviewer              | opencode-go/qwen3.5-plus      | deny              | allow | Audita el código generado buscando drift y bugs siguiendo `code-review-checklist`.                                                        |
| security-reviewer     | opencode-go/deepseek-v4-pro   | deny              | allow | Valida la postura de seguridad siguiendo `security-standards` y `keycloak-standard`.                                                      |
| spec-remediator       | opencode-go/deepseek-v4-flash | allow             | deny  | Corrige hallazgos de validación de forma iterativa siguiendo `spec-remediation`.                                                          |
| spec-validator        | opencode-go/deepseek-v4-pro   | allow limitado    | deny  | Valida la consistencia de los artefactos SDD siguiendo `spec-driven-development`.                                                         |
| task-decomposer       | opencode-go/qwen3.5-plus      | allow             | deny  | Descompone especificaciones en tareas atómicas siguiendo los contratos de `spec-driven-development`.                                      |
| test-architect        | opencode-go/qwen3.5-plus      | allow             | allow | Diseña la estrategia de pruebas y genera casos de test siguiendo `testing-strategy`.                                                      |
