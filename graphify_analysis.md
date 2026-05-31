# Análisis de Implementación: Graphify en Ecosistema de Agentes

Este documento presenta una evaluación técnica de **Graphify** (`graphifyy`), analizando su viabilidad dentro de la infraestructura actual de IA (basada en OpenCode, SDD, Context Pinning y Arquitectura Hexagonal) y proponiendo un plan de integración paso a paso.

---

## 1. ¿Qué es Graphify?
Graphify es una herramienta de optimización de contexto y RAG (Retrieval-Augmented Generation) estructural. Utiliza parsers rápidos (como `tree-sitter`) y opcionalmente LLMs locales para analizar un repositorio de código y documentación, extrayendo entidades (clases, funciones, tablas SQL, APIs, etc.) y sus relaciones (llamadas, importaciones, dependencias, flujo de datos).

El resultado se consolida en un directorio `graphify-out/` que contiene:
*   **`graph.json`**: Base de datos estructurada con el grafo de conocimiento del proyecto.
*   **`GRAPH_REPORT.md`**: Reporte markdown legible que destaca los "god nodes" (módulos centrales), comunidades funcionales y dependencias de arquitectura.
*   **`graph.html`**: Un mapa interactivo visualizable desde el navegador.

---

## 2. Pros y Contras de Graphify

### Pros 👍
*   **Eficiencia Extrema de Tokens:** Al alimentar al agente con subgrafos relevantes o el `GRAPH_REPORT.md` en lugar de código fuente completo y redundante, se reduce drásticamente el consumo de tokens (reportado de hasta 70x en proyectos medianos/grandes).
*   **Comprensión Arquitectónica y de Dependencias:** El RAG vectorial clásico es excelente para encontrar coincidencias semánticas ("¿dónde se define X?"), pero falla en responder consultas relacionales ("¿si modifico X, qué servicios, controladores y entidades Flyway se ven afectados?"). Graphify permite al agente "navegar" el grafo para responder esto con precisión.
*   **Persistencia entre Sesiones:** El grafo es local e incremental. No se requiere volver a indexar el proyecto completo en cada chat; el agente puede rehidratar contexto cargando el grafo en segundos.
*   **Integración Git-Ops:** Permite instalar ghooks (`graphify hook install`) para actualizar el grafo automáticamente en cada commit o de forma incremental (`graphify --update`).

### Contras 👎
*   **Costo Inicial de Inferencia (Cold Start):** La primera generación en repositorios masivos puede consumir tiempo de procesamiento. No obstante, al usar parsers estáticos locales para el análisis estructural básico, el impacto en tokens de API inicial es mínimo.
*   **Riesgo de Drift del Grafo:** Si los agentes o el desarrollador realizan cambios en el código sin actualizar el grafo, los agentes tomarán decisiones basadas en un mapa desactualizado.
*   **Curva de Adaptación del Agente:** Los prompts y skills de los agentes deben modificarse para que aprendan a consultar el CLI de `graphify` o a consumir `graphify-out/` como fuente de verdad de la topología del código.

---

## 3. ¿Cómo puede servir en tu infraestructura actual?

Actualmente utilizas un flujo estructurado de **Spec-Driven Development (SDD)**, donde varios agentes (`requirements-analyst`, `planner`, `spec-validator`, `executor`) interactúan con un **Shared Context** y aplican **Context Pinning** (para proteger la Master Spec y contratos OpenAPI). 

Graphify encaja perfectamente aquí como un **acelerador de contexto**:

| Agente | Uso de Graphify | Beneficio |
| :--- | :--- | :--- |
| **requirements-analyst** | Consulta el grafo existente para entender qué módulos de negocio tocan el nuevo requerimiento. | Evita ambigüedades sobre fronteras técnicas en el Brief de Requerimientos. |
| **planner** | Analiza dependencias estructurales en el grafo antes de diseñar el incremento. | Garantiza contratos OpenAPI libres de drifts y previene colisiones en base de datos. |
| **executor** | Ejecuta `graphify query` para identificar qué clases implementar y cómo integrarlas a la Arquitectura Hexagonal. | Reduce el tener que abrir y leer archivos innecesarios de adaptadores o entidades de forma manual. |
| **spec-validator / final-validation** | Compara el nuevo estado del grafo vs. el anterior para verificar que no haya regresiones estructurales. | Control automático de arquitectura limpia y acoplamientos no deseados. |

---

## 4. Plan de Implementación paso a paso

### Fase 1: Instalación y Validación Local (Manual)
1. Instalar la herramienta en el entorno del sistema de desarrollo:
   ```bash
   uv tool install graphifyy
   # o alternativamente
   pipx install graphifyy
   ```
2. Inicializar y testear en uno de tus repositorios de desarrollo:
   ```bash
   graphify install --project
   graphify --update
   ```
3. Evaluar el reporte generado en `graphify-out/GRAPH_REPORT.md` para verificar que la jerarquía y relaciones de clases de tu Arquitectura Hexagonal se representen correctamente.

### Fase 2: Creación de la Skill y Enlace en OpenCode
1. Definir una nueva skill en tu origen canónico de skills: `/home/cristiansrc/Documentos/Proyectos/shared-ai-services/skills/orchestration/graphify/SKILL.md`.
2. Crear un enlace simbólico (symlink) en la carpeta local de skills de OpenCode (`/home/cristiansrc/.config/opencode/skills/`).
3. En la skill, entrenar a tus agentes para que:
   * Antes de iniciar una implementación o planeación, verifiquen la existencia de `/graphify-out/GRAPH_REPORT.md` o `/graphify-out/graph.json`.
   * Usen comandos como `graphify query "..."` para recuperar contexto preciso en lugar de leer archivos masivos.
   * Ejecuten `graphify --update` como parte del proceso de pre-flight o tras completar tareas.

### Fase 3: Integración en los Agentes Críticos
1. **Rehidratación de Contexto (Context Curation):** Añadir `/graphify-out/GRAPH_REPORT.md` a la lista de archivos que `context-curator` analiza para armar el contexto mínimo del agente.
2. **Pre-Flight Check:** Añadir a la validación técnica obligatoria de `/home/cristiansrc/.gemini/skills/pre-flight-check/SKILL.md` (o skill equivalente) la ejecución automática de la actualización del grafo (`graphify --update`).

---

> [!IMPORTANT]
> **Preguntas de diseño para ti:**
> 1. ¿Prefieres que hagamos una prueba de concepto (PoC) instalando la herramienta en tu entorno local para ver cómo procesa uno de tus proyectos activos?
> 2. ¿Quieres que creemos la estructura de la Skill en tu directorio `shared-ai-services/skills` de una vez?
