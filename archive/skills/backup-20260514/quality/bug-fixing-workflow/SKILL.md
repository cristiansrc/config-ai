---
name: bug-fixing-workflow
description: Protocolo riguroso para la resolución de errores. Prioriza la reproducción empírica y la integridad arquitectónica sobre los parches rápidos.
---

# Bug Fixing Workflow

Esta skill define cómo los agentes deben abordar los fallos en el sistema.

## 1. Reproducción (Mandatorio)
Antes de proponer una solución, el agente debe:
1. Crear un test (Unitario o de Integración) que falle, demostrando el bug empíricamente.
2. Identificar el estado actual vs. el comportamiento esperado definido en la Master Spec.

## 2. Diagnóstico y Raíz (Root Cause)
- El agente debe explicar POR QUÉ ocurrió el fallo.
- ¿Es una violación de la arquitectura hexagonal? ¿Es un edge case no cubierto en la spec inicial? ¿Es un drift entre el código y el contrato OpenAPI?

## 3. Estrategia de Solución
- **Alineación:** La solución debe respetar la separación de capas (Dominio, Aplicación, Infraestructura).
- **No Side-Effects:** Evaluar si el fix afecta a otras partes del sistema.
- **SDD Integration:** Si el fix cambia una regla de negocio, el agente debe crear una `Delta Spec` de corrección.

## 4. Validación Final
- El test de reproducción ahora debe pasar (`BUILD SUCCESSFUL`).
- Se deben ejecutar los tests de regresión de la zona afectada para asegurar que no hay nuevas regresiones.
