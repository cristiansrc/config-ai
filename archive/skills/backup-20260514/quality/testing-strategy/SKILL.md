# Skill: Testing Strategy Multi-Stack (IDIOMA: ESPAÑOL)

Estrategia unificada de pruebas para asegurar la calidad y estabilidad del código en cualquier lenguaje.

## La Pirámide de Pruebas (2026)
- **Unitarios (70%)**: Lógica de dominio pura. Sin I/O. Muy rápidos.
- **Integración (20%)**: Validación de adaptadores y comunicación entre capas.
  - Uso de **Testcontainers** para bases de datos reales.
  - **MSW** para simular APIs externas en el frontend.
- **E2E (10%)**: Flujos críticos de usuario (Playwright para Web, Postman/Newman para APIs).

## Comportamiento Obligatorio
- **Cobertura**: Todo nuevo componente o servicio debe tener al menos un test unitario para el "happy path" y uno para el error principal.
- **Limpieza**: Los tests deben ser independientes y limpiar su estado después de ejecutarse.
- **Validation**: El agente `final-validation` debe ejecutar los tests antes de aprobar el incremento.
