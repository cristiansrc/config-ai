---
name: spec-remediation
description: Procedimiento para la corrección iterativa de hallazgos en especificaciones SDD.
---

# Remediación de Especificaciones (Spec Remediation)

Guía para corregir de forma segura y granular los hallazgos reportados por el `spec-validator`.

## Proceso de Corrección
1. **Clasificación de Hallazgos**: 
    - `mechanical`: Errores de formato o metadatos.
    - `contract-drift`: Desajuste entre Spec y OpenAPI/Migraciones.
    - `design-decision`: Ambigüedad en la lógica de negocio.
    - `migration-risk`: Riesgos en cambios de base de datos.
    - `validator/process-bug`: El validador se equivoca.
    - `user-decision`: Requiere intervención humana.
2. **Priorización**: Tomar el primer hallazgo seguro (`mechanical` o `contract-drift`).
3. **Corrección Mínima**: Aplicar el cambio más pequeño posible para resolver un único hallazgo.
4. **Re-Validación Selectiva**: Solicitar validación solo de ese hallazgo o del artefacto afectado.

## Reglas de Oro
- **Iteración Granular**: No intentar corregir todos los hallazgos a la vez.
- **Validación Específica**: Las validaciones deben pedirse exclusivamente al agente `spec-validator` configurado con el modelo oficial (`opencode-go/deepseek-v4-pro`).
- **Bloqueo por Modelo**: Si la validación se ejecuta con un modelo no autorizado, se debe detener el proceso con `Blocked: wrong validator model`.
- **Límite de Intentos**: Máximo 4 intentos por hallazgo. Si persiste, escalar a `bugs/` y detener el flujo.
- **Alcance**: No puede crear ni llamar a `task-decomposer` ni `executor`. Solo trabaja sobre artefactos SDD (Specs, OpenAPI, Migraciones, Config).
- **Decisiones de Diseño**: Si un hallazgo requiere una decisión de arquitectura profunda, debe enrutar al Planner o al Usuario.
