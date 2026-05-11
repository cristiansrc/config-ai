# Deuda Técnica - Automatización de IA con n8n

## Estado: Pendiente
**Descripción:** Implementar un flujo de revisión de código (AI Code Review) externo mediante n8n para proporcionar una "segunda opinión" en los Pull Requests creados por los agentes locales.

## Arquitectura Propuesta
1. **Trigger:** Webhook de GitHub (PR Created/Updated).
2. **Action:** n8n recibe el diff del PR.
3. **Reasoning:** n8n envía el diff a un agente de IA externo (ej. Anthropic Claude o OpenAI GPT-4o) con un System Prompt enfocado en detección de bugs lógicos y drift arquitectónico.
4. **Feedback:** n8n publica un comentario en el PR de GitHub con los hallazgos.

## Requisitos Previos
- Configurar el Webhook en el repositorio de GitHub apuntando a la instancia local de n8n.
- Asegurar que el túnel de n8n (si se usa) esté activo o que el webhook sea accesible.

## Beneficios
- Validación cruzada entre modelos locales (Ollama) y modelos en la nube.
- Proceso de QA asíncrono que no bloquea la máquina local del desarrollador.
