# Deuda Técnica - Automatización de IA con n8n

## Estado: Pendiente (Refinado 2026-05-12)
**Descripción:** Implementar un flujo de revisión de código (AI Code Review) externo mediante n8n para proporcionar una "segunda opinión" crítica en los Pull Requests, con enfoque en **Retro-Validación Arquitectónica** y cumplimiento de la **Master Spec**.

## Arquitectura Refinada
1. **Trigger:** Webhook de GitHub (Pull Request: `opened`, `synchronize`).
2. **Context Gathering:**
   - n8n obtiene el `diff` del PR.
   - n8n obtiene la `master_spec.md` y el contrato `openapi.yaml` actualizados del repositorio.
   - n8n obtiene los reportes de validación local del directorio `docs/specs/.working/`.
3. **Reasoning (Deep Reasoning Step):**
   - n8n envía el contexto consolidado a un modelo de razonamiento profundo (ej. Claude 3.5 Sonnet o GPT-4o).
   - **System Prompt:** Enfocado en detectar "Architectural Drift" (desviaciones que los agentes locales pudieron pasar por alto) y regresiones contra la Master Spec global.
4. **Feedback & Guardrails:**
   - n8n publica un comentario estructurado en el PR (Markdown).
   - Si se detectan hallazgos `critical` o `high`, el flujo marca el check del PR como `failed`.
   - Genera una alerta local para que el agente `spec-remediator` tome el hallazgo externamente validado.

## Alineación con Estándares Locales
- **Idempotencia:** El flujo debe usar el `SHA` del commit como clave para evitar comentarios duplicados en el mismo PR.
- **Error Standards:** El feedback debe seguir el esquema de errores REST definido en el proyecto (timestamp, code, message, path).
- **Retro-Validation:** n8n debe actuar como el "Juez Supremo" de la Master Spec, validando que el incremento no comprometa la integridad a largo plazo del sistema.

## Beneficios
- **Validación Cruzada:** Contraste entre el razonamiento local (`Qwen 3.6 35B`) y modelos cloud de última generación.
- **QA Asíncrono:** Auditoría continua sin consumo de recursos locales de GPU durante la implementación.
- **Seguridad Extra:** Detección de patrones de ataque complejos que requieren mayor ventana de contexto.
