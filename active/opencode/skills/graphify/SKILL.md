---
name: graphify
description: Optimización de contexto, análisis de dependencias de código y reducción de consumo de tokens mediante grafos de conocimiento estructurados.
---

# Graphify Skill

Esta skill define el estándar operativo para el uso de **Graphify** (`graphifyy`) dentro del flujo de desarrollo de software. Su objetivo es optimizar el consumo de la ventana de contexto de los agentes de IA, prevenir regresiones estructurales y proveer un mapa relacional rápido del codebase.

## 1. Detección y Disponibilidad
Un agente debe asumir que un proyecto tiene Graphify configurado si se cumple alguna de estas condiciones en el repositorio activo:
* Existe una carpeta `graphify-out/` en el directorio raíz o bajo `docs/specs/`.
* Existe un archivo `graphify-out/graph.json` o `graphify-out/GRAPH_REPORT.md`.

## 2. Comandos Operativos del CLI
Cuando la herramienta está disponible, el agente puede interactuar con ella mediante la consola de comandos usando las siguientes llamadas:
* **Actualización del Grafo:** `graphify --update` o `graphify .` (en Windows) para re-indexar de forma incremental los archivos modificados.
* **Consulta Semántica/Estructural:** `graphify query "<pregunta>"` para consultar dependencias o buscar cómo se comunican las entidades en base al grafo, evitando la lectura extensiva de archivos fuente en paralelo.
* **Verificación de Relaciones:** `graphify export callflow-html` para exportar el mapa de llamadas e identificar dependencias circulares.

## 3. Integración en el Ciclo de Vida (SDD)
* **Planner y Requirements Analyst:**
  * Al iniciar una planeación, se debe leer obligatoriamente `graphify-out/GRAPH_REPORT.md` para entender el impacto sobre los componentes de la Arquitectura Hexagonal.
  * Utilizar `graphify query` para rastrear los adaptadores, servicios o entidades de persistencia asociados al flujo que se desea planificar.
* **Executor:**
  * Para implementar código de forma precisa sin abrir archivos de forma masiva, usar el grafo para encontrar los archivos con dependencias directas o el punto exacto de integración de puertos y adaptadores.
  * Tras realizar modificaciones del código, es obligatorio ejecutar `graphify --update` antes de proceder al Pre-flight Check.
* **Spec Validator y Final Validation:**
  * Verificar que el grafo y el reporte del grafo estén actualizados y sin drift con respecto a los archivos de código fuente creados o modificados.

## 4. Estructura de Salida
Los artefactos generados en `graphify-out/` son:
* **`graph.json`**: Estructura de datos indexada del grafo.
* **`GRAPH_REPORT.md`**: Reporte legible de "god nodes" (nodos centrales), comunidades y dependencias críticas.
* **`graph.html`**: Mapa interactivo visualizable por navegador.
