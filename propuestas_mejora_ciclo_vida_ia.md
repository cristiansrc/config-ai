# Propuestas de Mejora para el Ciclo de Vida de Desarrollo de IA (SDLC-IA)

Basado en el análisis de las mejores prácticas y tendencias de la industria en **Agentic Software Development Lifecycle (ASDLC)** (como patrones de robustez en sistemas multi-agente, resiliencia contra loops infinitos de tokens y optimización de memoria), se proponen las siguientes mejoras para adoptar en tu flujo de agentes.

---

## 1. Límite de Auto-Sanación y Escape al Humano (Self-Healing Loop Guard)
*   **El Problema:** Un comportamiento común y costoso en agentes autónomos de codificación (`executor`, `refactor`) es entrar en loops infinitos de corrección de código. Cuando un test de integración o compilación falla, el agente reintenta modificar el archivo una y otra vez, consumiendo miles de tokens sin resolver el problema de raíz.
*   **La Propuesta:** Implementar un **Guard de Bucle de Reintentos** en la skill [pre-flight-check](file:///home/cristiansrc/Documentos/config-ai/active/opencode/skills/pre-flight-check/SKILL.md) y en el agente [executor](file:///home/cristiansrc/Documentos/config-ai/active/opencode/agents/executor.md):
    *   *Regla:* El agente obrero tiene permitido un **máximo de 3 intentos** autónomos para corregir un fallo de compilación o de pruebas unitarias.
    *   *Mecanismo de Escape:* Si al tercer intento la verificación sigue en estado `fail`, el agente debe detenerse inmediatamente, marcar la tarea como `blocked` y generar un informe estructurado de error (`escape-report.md`) detallando la hipótesis de fallo para que el programador humano intervenga.

---

## 2. Memoria de Lecciones Aprendidas (`MEMORY.md`)
*   **El Problema:** La rehidratación de contexto actual lee especificaciones y contratos activos, pero los agentes carecen de memoria a largo plazo sobre errores históricos complejos o decisiones de diseño repetitivas que el usuario ya resolvió en el pasado.
*   **La Propuesta:** Establecer el archivo canónico **`MEMORY.md`** en la raíz del proyecto (o del Workspace):
    *   *Estructura:* Se registran entradas con el formato: `[Fecha] [Módulo] - Error/Desafío: <descripción> -> Solución Aplicada: <solución> -> Regla para el Agente: <instrucción para evitar reincidencia>`.
    *   *Uso:* Añadir `MEMORY.md` al [context-pinning](file:///home/cristiansrc/Documentos/config-ai/active/opencode/skills/context-pinning/SKILL.md) para que el `planner` y el `executor` lo lean obligatoriamente. Esto evita que los agentes repitan bugs de arquitectura previamente solucionados.

---

## 3. Pruebas de Evaluación de Comportamiento de Agentes (EvalOps)
*   **El Problema:** Cuando se actualiza un prompt o se cambia de modelo de LLM (por ejemplo, pasar de Qwen a DeepSeek), es difícil saber si los agentes han sufrido una regresión en su capacidad para seguir las especificaciones o si introducen alucinaciones en el código.
*   **La Propuesta:** Crear un pipeline básico de **Evaluación de Prompts (Evals)**:
    *   *Mecanismo:* Definir un conjunto de "casos de prueba" estáticos para los prompts (por ejemplo, pasarle una especificación deliberadamente ambigua al `spec-validator` y verificar que el resultado devuelva `not ready`). Si el validador aprueba la especificación errónea, la evaluación de prompt falla, alertando sobre degradación del modelo.

---

## 4. Clasificación Semántica de Cambios en Git-Ops
*   **El Problema:** Las fusiones y promociones de ramas en proyectos grandes pueden volverse caóticas si los commits automáticos de los agentes no tienen una trazabilidad clara del incremento.
*   **La Propuesta:** Adoptar el estándar de **Conventional Commits** estricto para los agentes obreros y el agente de Git-Ops:
    *   `feat(<increment-name>): ...` para nuevas funcionalidades.
    *   `fix(<increment-name>): ...` para corrección de bugs del incremento.
    *   `docs(<increment-name>): ...` para documentación y especificaciones.
    *   `refactor(<increment-name>): ...` para cambios internos sin alteración de comportamiento.
    *   `chore(<increment-name>): ...` para deudas técnicas resueltas.
