---
name: code-review-checklist
description: Lista de verificación para el Reviewer Agent.
---

# Code Review Checklist

Esta lista de verificación define los estándares de calidad mínimos que deben validarse en cada revisión de código para asegurar la mantenibilidad y robustez del sistema.

## Puntos de Revisión

### Naming Semántico
- Los nombres de variables, funciones y clases deben ser auto-descriptivos.
- Uso de verbos para funciones y sustantivos para variables/clases.
- Consistencia con el dominio del negocio (Ubiquitous Language).

### Duplicidad (DRY)
- Identificación de lógica repetida que deba abstraerse.
- Reutilización de componentes y utilidades existentes.

### Complejidad Ciclomática
- Evitar anidamiento excesivo (máximo 3 niveles).
- Descomposición de funciones largas en funciones pequeñas y enfocadas.
- Preferencia por guard clauses sobre estructuras if-else complejas.

### Manejo de Errores
- Implementación de bloques try-catch en puntos críticos.
- Uso de excepciones personalizadas o tipos de error específicos.
- Logging adecuado del contexto del error sin exponer datos sensibles.

### Seguridad Básica
- Validación y sanitización de inputs.
- Prevención de vulnerabilidades comunes (SQL Injection, XSS).
- Manejo seguro de secretos y variables de entorno.

### Adherencia a la Arquitectura Hexagonal
- Separación clara entre Dominio, Aplicación e Infraestructura.
- Las dependencias deben apuntar hacia adentro (hacia el Dominio).
- Uso de interfaces/puertos para el desacoplamiento de adaptadores externos.
