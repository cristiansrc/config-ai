---
name: documentation-standards
description: Estándares de documentación técnica y READMEs.
---

# Estándares de Documentación

Define los requisitos mínimos y formatos permitidos para la documentación técnica dentro del ecosistema de servicios.

## Componentes de Documentación

### Diagramas Mermaid
- Uso obligatorio de Mermaid.js para diagramas de arquitectura, secuencia y estados.
- Los diagramas deben estar integrados directamente en los archivos Markdown.
- Mantener los diagramas actualizados con los cambios estructurales.

### Documentación de APIs
- Especificación obligatoria mediante Swagger/OpenAPI (v3+).
- Descripción detallada de cada endpoint, parámetros y esquemas de respuesta.
- Inclusión de ejemplos de peticiones y respuestas exitosas/fallidas.

### Guías de Instalación
- Pasos claros y secuenciales para configurar el entorno de desarrollo local.
- Listado de prerrequisitos (versiones de lenguajes, herramientas, bases de datos).
- Comandos de inicialización, ejecución de tests y construcción.

### Variables de Entorno
- Documentación de todas las variables necesarias en archivos `.env.example`.
- Descripción del propósito de cada variable y sus posibles valores.
- Clasificación de variables por entorno (Desarrollo, Staging, Producción).
