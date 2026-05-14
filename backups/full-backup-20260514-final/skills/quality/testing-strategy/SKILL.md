---
name: testing-strategy
description: Estrategia unificada de pruebas y cobertura (85%-100%) para múltiples stacks tecnológicos.
---

# Estrategia Global de Pruebas y Cobertura

Guía mandatoria para asegurar la calidad mediante pruebas automáticas y métricas de cobertura estrictas.

## Objetivos de Cobertura
- **Mínimo Aceptable**: **85%** de cobertura por archivo testable.
- **Ideal**: **100%** de cobertura.
- **Bloqueo**: Si un archivo testable no alcanza el 85%, el agente `final-validation` debe rechazar el incremento.

## Qué Testear vs Qué Excluir

### ✅ Archivos Testables (Obligatorios)
- **Domain Services / Entities**: Lógica de negocio pura (100% ideal).
- **Application Use Cases**: Orquestación y reglas de aplicación.
- **Infrastructure Adapters**: Lógica de integración, mapeo complejo y validaciones personalizadas.
- **Utility Classes / Helpers**: Funciones puras de soporte.

### ❌ Archivos Excluidos (No cuentan para cobertura)
- **DTOs / Request / Response**: Clases de datos simples sin lógica.
- **Entities de Persistencia**: Si solo contienen mapeos `@Column`.
- **Configuraciones**: Clases `@Configuration`, archivos `.env`, `.yaml`, `.json`.
- **Excepciones Personalizadas**: Si solo heredan de una base.
- **Interfaces / Ports**: Sin implementación.
- **Mappers Generados**: (ej: clases generadas por MapStruct).

## Herramientas por Stack

| Stack | Herramienta de Test | Herramienta de Cobertura | Reporte |
|---|---|---|---|
| **Spring Boot (Java/Kotlin)** | JUnit 5 + Mockito | JaCoCo | HTML / XML |
| **FastAPI (Python)** | Pytest + HTTPIX | pytest-cov | HTML / XML (lcov) |
| **Node.js / React / Angular** | Vitest / Jest | Istanbul (nyc) | LCOV |

## Mejores Prácticas
- **Independencia**: Cada test debe ser capaz de ejecutarse por separado.
- **Nomenclatura**: `should_Result_when_Condition` (ej: `should_CreateOrder_when_ValidRequest`).
- **First-Class Citizens**: El código de test es tan importante como el de producción. No usar "hacks" para aumentar cobertura.
- **TDD / SDD**: Los tests se diseñan basándose en la especificación validada.
