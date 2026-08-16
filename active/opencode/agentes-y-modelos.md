# Agentes y Modelos OpenCode

Ultima actualizacion: 2026-08-16

Fuente activa:
- Configuracion: `/home/cristiansrc/.config/opencode/opencode.json`
- Agentes: `/home/cristiansrc/.config/opencode/agents/`
- Skills: `/home/cristiansrc/.config/opencode/skills/`
- Backup de agentes: `/home/cristiansrc/Documentos/config-ai/archive/full-backup-20260514-final/agents/`
- Backup de skills: `/home/cristiansrc/Documentos/config-ai/archive/full-backup-20260514-final/skills/`

Regla de mantenimiento:
- Cualquier cambio en agentes, modelos, permisos o skills debe actualizar este archivo y `/home/cristiansrc/Documentos/config-ai/resumen-configuracion-ia.txt` en la misma sesion.
- Idioma obligatorio: Todas las respuestas e interacciones de los agentes con el usuario deben ser en ESPAÑOL.
- Politica de idioma de agentes: La definicion operativa, responsabilidades, reglas y guias de cada agente deben estar en ESPAÑOL. Se mantienen en INGLES los nombres de agentes/skills, estados canonicos, headings, rutas, comandos, campos de protocolo y tokens exactos como `ready`, `blocked`, `validated-not-executed`, `## Spec Validator Approval` o `Blocked: ...`.
- Contratos de error por stack: Spring Boot Java usa `springboot-java-rest-error-response-standards`, Spring Boot Kotlin usa `springboot-kotlin-rest-error-response-standards` y FastAPI usa `fastapi-rest-error-response-standards`.
- Convenciones de stack: `nodejs-stack`, `python-stack`, `fastapi-stack`, `springboot-stack`, `java-stack`, `kotlin-stack` y `golang-stack` son la fuente de verdad para reglas tecnicas de cada runtime.
- Estándar de Testing Funcional: `functional-testing-standard` define la estrategia de planeación, reporte y corrección de pruebas UI/E2E en frontends utilizando Puppeteer MCP o frameworks locales.
- Cambio operativo vigente: Planner puede crear o actualizar unicamente el `.gitignore` raiz del repositorio activo ademas de specs/OpenAPI, para excluir artefactos no versionables de specs y codigo generado sin ocultar artefactos canonicos.
- Cambio operativo vigente: Spec Remediator debe invocar validaciones solo mediante `spec-validator` con `opencode-go/gpt-5.6-luna`; cualquier validacion ejecutada con otro modelo debe bloquearse como `Blocked: wrong validator model`.
- Estándares de Calidad y Pruebas Avanzadas: `code-quality-and-sonarqube` (SonarScanner, SpotBugs, Ruff, golangci-lint, script ./verify-code.sh), `performance-testing-k6` (k6 load testing, p95 < 200ms), `eval-ops-agent-benchmarks` (benchmarks de regresión de agentes), `zero-downtime-migrations` (Expand/Contract DB), `root-cause-analysis` (RCA protocol), `api-governance-linter` (OpenAPI breaking changes) y `testing-strategy` (TDD Red-Green-Refactor, ArchUnit, Concurrencia).
- Estructura de Solution Workspace (OPCIONAL): La pertenencia a un Solution Workspace está condicionada a que la carpeta padre del proyecto se llame exactamente `projects/`.
  - Si el padre NO es `projects/`: El proyecto es STANDALONE; no requiere ni debe tener documentación enterprise ni Master Spec global.
  - Si el padre ES `projects/`: El proyecto es parte de una solución. Los agentes deben usar esta carpeta como frontera para distinguir contexto LOCAL de GLOBAL.
  - Gestión de Git (Enterprise Architect): El `enterprise-architect` debe configurar el `.gitignore` de la raíz del Workspace para ignorar el contenido de `projects/` (`projects/**`), ya que los proyectos se versionan independientemente.
  - Inicialización: La carpeta `projects/` debe ser creada automáticamente por el agente al detectar que se inicia un flujo de Solution Workspace si aún no existe.
- Gestión de Paquetes JS/TS: Queda ESTRICTAMENTE PROHIBIDO el uso de `npm` para cualquier tarea (Node, React, Angular, etc.). Se debe utilizar exclusivamente `pnpm`. Esto responde a requerimientos de seguridad y eficiencia. Los agentes deben fallar si detectan un `package-lock.json` y proponer la migración a `pnpm-lock.yaml`. Se deben seguir las mejores prácticas de pnpm para la gestión de dependencias.
- Soporte de Contexto mediante Grafos (Graphify): Para optimizar el contexto de los agentes, reducir el consumo de tokens y asegurar la trazabilidad arquitectónica, se utiliza Graphify en los proyectos compatibles. Los agentes deben consultar y actualizar el grafo de conocimiento según define la skill `graphify`.
- Aislamiento Operativo de Git: Queda ESTRICTAMENTE PROHIBIDO para todos los agentes de desarrollo, pruebas o documentación ejecutar cualquier comando Git (`git add`, `git commit`, `git push`, `git checkout`, etc.) en la terminal. Toda operación relacionada con Git debe delegarse de forma exclusiva al agente `git-executor`.



Perfil LM Studio persistente:
- `lmstudio/qwen/qwen3.6-35b-a3b`: context length `152563`, GPU offload ratio `26/64` capas, K/V cache `Q4_0`. OpenCode declara el mismo limite de contexto para que no intente usar el valor anterior.

| Agente                | Modelo                        | Editar            | Bash  | Descripcion                                                                                                                                       |
|-----------------------|-------------------------------|-------------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| api-governance-agent  | opencode/gpt-5.6-terra        | deny              | allow | Audita contratos OpenAPI buscando Breaking Changes, backward compatibility y reglas semver.                                                        |
| architect-executor    | opencode-go/gpt-5.6-luna      | allow             | allow | Implementa tareas complejas y arquitectura local con razonamiento denso cuando NO existe especificación SDD completa.                               |
| bug-diagnostician     | opencode-go/glm-5.2           | deny              | allow | Realiza análisis de causa raíz (RCA) e inspección de logs/stack traces antes de implementar correcciones.                                          |
| context-curator       | opencode-go/gpt-5.6-luna      | deny              | deny  | Gestiona la ventana de contexto (Temp 0.10) y reduce ruido siguiendo `context-curation` y `context-pinning`.                                       |
| database-architect    | opencode/deepseek-v4-flash-free    | allow             | allow | Diseña esquemas DB relacionales, migraciones Flyway/Liquibase e índices sin tiempo de inactividad (Zero-Downtime DB Migrations).                   |
| devops-architect      | opencode/deepseek-v4-flash-free    | allow             | allow | Especialista en Infraestructura como Código y CI/CD siguiendo `docker-standard` y `observability-standard`.                                       |
| documentation         | opencode/deepseek-v4-flash-free    | allow             | deny  | Gestiona el ciclo de vida de la documentación siguiendo `documentation-lifecycle` y `documentation-standards`.                                    |
| enterprise-architect  | opencode-go/gpt-5.6-luna      | allow             | deny  | Define el System Landscape, fronteras de microservicios y flujos globales siguiendo `enterprise-architecture-standard`.                           |
| enterprise-spec-validator| opencode-go/gpt-5.6-luna   | allow             | deny  | Valida la coherencia global del Solution Workspace, contratos de integración y deuda técnica global siguiendo `workspace-coordination`.          |
| executor              | opencode/deepseek-v4-flash-free    | allow             | allow | Implementa código verificado (Temp 0.15) cuando EXISTE especificación SDD validada siguiendo los estándares del stack correspondiente.              |
| final-validation      | opencode-go/glm-5.2           | deny              | allow | Garantiza la calidad final y cobertura mínima siguiendo `testing-strategy` y `pre-flight-check`.                                                  |
| functional-tester-agent| opencode/deepseek-v4-flash-free   | allow             | allow | Diseña plan, ejecuta y valida pruebas funcionales y UI/E2E en frontends con Puppeteer MCP.                                                         |
| git-executor          | opencode/deepseek-v4-flash-free    | allow             | allow | Centraliza de manera exclusiva todas las interacciones del repositorio con Git (ramas, commits, checkout, pushes).                                |
| master-orchestrator   | opencode/kimi-k3              | deny              | allow | Agente Maestro / Orquestador Contextual. Mantiene el contexto de la spec y delega tareas a subagentes de forma estructurada.                      |
| planner               | opencode/gpt-5.6-terra        | allow             | deny  | Planifica incrementos SDD y diseña contratos. Consulta a `solution-architect` para decisiones de patrones complejos.                              |
| refactor              | opencode-go/gpt-5.6-luna      | allow             | allow | Refactoriza código existente siguiendo `refactor-patterns` y `refactor-hexagonal-bridge`.                                                         |
| requirements-analyst  | opencode-go/glm-5.2           | allow             | deny  | Realiza el levantamiento de requerimientos funcionales siguiendo `requirements-gathering`.                                                        |
| reviewer              | opencode/gpt-5.6-terra        | deny              | allow | Audita el código generado buscando drift y bugs siguiendo `code-review-checklist`.                                                                |
| security-reviewer     | opencode/gpt-5.6-terra        | deny              | allow | Valida la postura de seguridad siguiendo `security-standards` y `keycloak-standard`.                                                              |
| solution-architect    | opencode-go/gpt-5.6-luna      | allow             | deny  | Elige patrones de diseño siguiendo `design-patterns-standard`. Colabora con `enterprise-architect` para alinear el diseño local con el global.    |
| spec-remediator       | opencode/deepseek-v4-flash-free    | allow             | deny  | Corrige hallazgos de validación de forma iterativa siguiendo `spec-remediation`.                                                                  |
| spec-validator        | opencode-go/gpt-5.6-luna      | allow limitado    | deny  | Valida la consistencia de los artefactos SDD siguiendo `spec-driven-development`.                                                                 |
| task-decomposer       | opencode-go/gpt-5.6-luna      | allow             | deny  | Descompone especificaciones en tareas atómicas siguiendo los contratos de `spec-driven-development`.                                             |
| test-architect        | opencode/deepseek-v4-flash-free    | allow             | allow | Diseña la estrategia de pruebas y genera casos de test siguiendo `testing-strategy`.                                                              |
| hyprmind-orchestrator  | opencode/kimi-k3              | allow             | allow | (V.I.E.R.N.E.S.) Orquestador conversacional principal de tu sistema y manejador del workspace.                                                     |
| hyprmind-vision-analyst| opencode/deepseek-v4-flash-free   | deny              | deny  | El "Ojo Biónico" que procesa y explica tus capturas de pantalla o interfaces visuales.                                                             |
| hyprmind-deep-thinker  | opencode-go/qwen3.7-plus      | deny              | deny  | Filósofo y motor de razonamiento denso para discusiones complejas o diseño abstracto.                                                              |


