---
name: git-ops
description: Gestión profesional del ciclo de vida de Git y GitHub. Automatiza la creación de ramas, commits semánticos y Pull Requests siguiendo estándares de la industria y el flujo SDD.
---

# Git Ops Skill

Esta skill permite a los agentes gestionar el flujo de trabajo de Git de forma autónoma y profesional, asegurando consistencia en los mensajes de commit y la estructura del repositorio.

## 1. Convenciones de Ramas (Branching)

Antes de realizar cambios, el agente debe asegurarse de estar en la rama correcta o crear una nueva si la tarea lo requiere.

- **Formato:** `tipo/descripcion-breve`
- **Tipos:**
  - `feature/`: Nuevas funcionalidades o mejoras.
  - `fix/`: Corrección de errores.
  - `docs/`: Cambios solo en documentación.
  - `refactor/`: Cambios en el código que no añaden funcionalidad ni corrigen errores.
  - `chore/`: Tareas de mantenimiento (actualización de dependencias, configs).

## 2. Mensajes de Commit (Conventional Commits)

Los mensajes deben ser claros y seguir el estándar `tipo(scope): descripcion`.

- **Tipos:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`.
- **Scope:** El módulo o capa afectada (ej. `api`, `auth`, `ui`, `db`).
- **Descripción:** En minúsculas, tiempo presente, máximo 50 caracteres.

**Ejemplo:** `feat(auth): implement JWT token rotation`

## 3. Flujo de Trabajo Operativo

El agente debe seguir este orden estrictamente:

### Paso A: Verificación (Pre-commit)
Nunca realizar un commit si el código no ha sido verificado.
- Ejecutar tests relevantes con el gestor del stack: `pnpm test`, `mvn test`, `pytest`, etc.
- Ejecutar linter/formater con el gestor del stack: `pnpm run lint`, `prettier --check`.
- En proyectos JavaScript/TypeScript, no usar `npm`; si existe `package-lock.json`, detenerse y proponer migración a `pnpm-lock.yaml`.

### Paso B: Preparación de Cambios
1. Identificar archivos modificados relacionados estrictamente con la tarea.
2. Hacer `git add` de los archivos específicos. Evitar `git add .` si hay cambios no relacionados.

### Paso C: Commit Semántico
Generar el mensaje basado en el análisis de los cambios realizados. Si hay dudas sobre el scope, usar el nombre del directorio principal afectado.

### Paso D: Publicación y PR (GitHub)
Si la tarea incluye el cierre de la implementación:
1. `git push origin <branch-name>`.
2. Utilizar el MCP de GitHub (`github_create_pull_request`) para abrir el PR.
3. El título del PR debe ser el mismo que el del commit principal.
4. El cuerpo del PR debe incluir un resumen de los cambios y mencionar si cierra algún issue (ej. `Closes #123`).

## 4. Integración con SDD

- **Planner/Task Decomposer:** Deben indicar si la tarea requiere una nueva rama.
- **Executor:** Debe realizar commits atómicos por cada tarea completada del desglose.
- **Final Validation:** Debe confirmar que el PR ha sido creado correctamente antes de dar la sesión por concluida.

## 5. Comandos de Referencia Rápida

- Crear rama: `git checkout -b feature/nueva-feat`
- Ver cambios: `git status` y `git diff --cached`
- Commit: `git commit -m "feat(scope): desc"`
- Push: `git push origin HEAD`
