---
name: testing-strategy
description: Estrategia unificada de pruebas, cobertura y evidencia de calidad para múltiples stacks tecnológicos.
---

# Estrategia Global de Pruebas y Cobertura

Guía mandatoria para asegurar calidad mediante pruebas automáticas, cobertura estricta y evidencia verificable. Esta skill define qué se debe probar; `pre-flight-check` define cuándo y cómo ejecutar/reportar la verificación.

## Objetivos de Cobertura
- **Mínimo Aceptable**: **85%** de cobertura por archivo testable.
- **Ideal**: **100%** de cobertura.
- **Bloqueo**: Si un archivo testable no alcanza el 85%, el agente `final-validation` debe rechazar el incremento.
- **Unidad de Medición**: La cobertura se evalúa por archivo testable, no solo por promedio global del proyecto.
- **Evidencia**: Reportar ruta del reporte de cobertura o comando ejecutado. Si la herramienta no está configurada, Planner/Test Architect debe incluir tarea para configurarla.

## Qué Testear vs Qué Excluir

### ✅ Archivos Testables (Obligatorios)
- **Domain Services / Value Objects / Domain Logic**: Lógica de negocio pura (100% ideal).
- **Application Use Cases**: Orquestación, reglas de aplicación, idempotencia y límites transaccionales.
- **Infrastructure Adapters**: Lógica de integración, mapeo complejo, queries custom, retries, timeouts y validaciones personalizadas.
- **Controllers / Handlers**: Validación de entrada, status codes, error shape, auth/authz y contract behavior cuando no esté cubierto por tests de API.
- **Frontend State / Forms / Guards**: Validación, loading/empty/error/success, route guards y lógica de transformación.
- **Workflow / Queue / Job Handlers**: Payloads, retries, idempotencia y failure handling.
- **Utility Classes / Helpers**: Funciones puras de soporte.

### ❌ Archivos Excluidos (No cuentan para cobertura)
- **DTOs / Request / Response**: Clases de datos simples sin lógica.
- **Entities de Persistencia**: Si solo contienen mapeos `@Column`.
- **Configuraciones**: Clases `@Configuration`, archivos `.env`, `.yaml`, `.json`.
- **Excepciones Personalizadas**: Si solo heredan de una base.
- **Interfaces / Ports**: Sin implementación.
- **Mappers Generados**: (ej: clases generadas por MapStruct).
- **Código Generado**: Clientes OpenAPI generados, stubs o artefactos autogenerados sin lógica manual.
- **Bootstrap Simple**: Entrypoints sin lógica propia, salvo que configuren comportamiento crítico.

## Pirámide de Pruebas
- **Unit Tests**: Dominio, use cases, validators, mappers manuales y utilities. Deben ser rápidos y determinísticos.
- **Integration Tests**: DB, repositories, Flyway, Testcontainers, HTTP clients, queues, n8n/webhooks y adapters externos.
- **Contract/API Tests**: Verifican OpenAPI, status codes, auth, error shape, schemas y compatibilidad de payloads.
- **E2E / Flow Tests**: Cubren flujos críticos de usuario o negocio. Deben ser pocos, estables y enfocados en riesgo.
- **Security Regression Tests**: Casos de auth/authz, tenant boundary, input validation, rate limits o abuso cuando aplique.

## Herramientas por Stack

| Stack | Herramienta de Test | Herramienta de Cobertura | Reporte |
|---|---|---|---|
| **Spring Boot (Java/Kotlin)** | JUnit 5 + Mockito/MockK + Testcontainers | JaCoCo | HTML / XML |
| **FastAPI (Python)** | pytest + httpx/TestClient | pytest-cov | HTML / XML / terminal |
| **Node.js / React / Angular** | Vitest / Jest / Testing Library / Playwright cuando aplique | Istanbul / v8 coverage | LCOV / HTML |
| **n8n / Workflows** | workflow fixtures + webhook/job simulations | N/A o cobertura de wrappers | evidencia de ejecución |

## Comandos de Referencia
- Spring Boot Gradle: `./gradlew test jacocoTestReport jacocoTestCoverageVerification`.
- Spring Boot Maven: `./mvnw test jacoco:report`.
- FastAPI: `pytest --cov`.
- Node/React/Angular: `pnpm test`, `pnpm run coverage`, `pnpm run test:e2e` si existe.
- Docker/integración: usar comandos definidos por el proyecto y reportarlos vía `pre-flight-check`.

## Mejores Prácticas
- **Independencia**: Cada test debe ser capaz de ejecutarse por separado.
- **Nomenclatura**: `should_Result_when_Condition` (ej: `should_CreateOrder_when_ValidRequest`).
- **First-Class Citizens**: El código de test es tan importante como el de producción. No usar "hacks" para aumentar cobertura.
- **TDD / SDD**: Los tests se diseñan basándose en la especificación validada.
- **Determinismo**: No usar sleeps frágiles, dependencias de reloj real sin control, orden implícito ni estado compartido.
- **Datos de Prueba**: Usar fixtures/builders claros. No depender de datos globales ocultos.
- **Mocking Responsable**: Mockear bordes externos, no la lógica que se quiere verificar.
- **Regression First**: Todo bug corregido debe incluir test de regresión que falle antes del fix cuando sea viable.
- **Risk-Based Testing**: Priorizar seguridad, dinero, datos, transacciones, permisos, integraciones y flujos de alto volumen.
- **No Coverage Gaming**: No escribir tests que solo ejecutan getters/setters o snapshots vacíos para subir porcentaje.

## Reglas de Bloqueo
- Si cambia comportamiento productivo y no hay test que lo proteja, marcar `blocked` salvo justificación explícita.
- Si cambia API/error shape/auth y no hay test de contrato o controller/API, marcar `blocked`.
- Si cambia persistencia/migración/query y no hay test de integración o evidencia equivalente, marcar `blocked`.
- Si el coverage por archivo testable queda por debajo de 85%, `final-validation` debe rechazar.
- Si una exclusión de cobertura oculta lógica real, debe tratarse como finding.

## Reporte Esperado
Todo reporte de pruebas debe incluir:
- Comandos ejecutados.
- Resultado (`pass`, `fail`, `blocked`, `skipped-with-reason`).
- Cobertura observada por archivo testable cuando esté disponible.
- Tests agregados/modificados.
- Riesgos residuales y verificaciones no ejecutadas con razón.
