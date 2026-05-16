---
name: testing-strategy
description: Estrategia de pruebas para arquitectura hexagonal.
---

# Estrategia de Pruebas

Pirámide de pruebas diseñada para validar la lógica de negocio y la integración con sistemas externos en una arquitectura hexagonal.

## Tipos de Pruebas

### 1. Pruebas Unitarias (Unit Tests)
- **Alcance**: Capas de `domain` y `application`.
- **Herramientas**: Mockito (para Java) o MockK (para Kotlin).
- **Objetivo**: Validar la lógica de negocio y los casos de uso en total aislamiento, simulando los puertos de salida.

### 2. Pruebas de Integración (Integration Tests)
- **Alcance**: Capa de `infrastructure`.
- **Herramientas**: `@DataJpaTest` para persistencia o Testcontainers para levantar una base de datos PostgreSQL real.
- **Objetivo**: Validar que los adaptadores (repositorios, clientes externos) interactúan correctamente con los sistemas reales o sus representaciones.

### 3. Validación de Contratos API
- **Alcance**: Adaptadores de entrada (Controladores).
- **Herramientas**: `MockMvc` o `WebTestClient`.
- **Objetivo**: Asegurar que la implementación cumple estrictamente con el contrato definido en OpenAPI (tipos de datos, códigos de estado, estructura de respuesta).

## Reglas Generales
- Las pruebas deben ser independientes y repetibles.
- Se debe buscar una alta cobertura en la capa de dominio, donde reside la complejidad del negocio.
