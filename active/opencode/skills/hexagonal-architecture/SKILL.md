---
name: hexagonal-architecture
description: Implementación de Puertos y Adaptadores (Clean Architecture) en Spring Boot con mejores prácticas de desacoplamiento y dominio puro.
---

# Arquitectura Hexagonal (Puertos y Adaptadores)

Guía para la implementación de una arquitectura limpia que protege la lógica de negocio de cambios tecnológicos.

## Estructura de Paquetes y Responsabilidades

### 1. Núcleo de Dominio (`domain`)
- **Entidades**: Objetos con identidad propia que contienen lógica de negocio.
- **Value Objects**: Objetos inmutables por valor (ej: `Email`, `Price`).
- **Domain Services**: Lógica que involucra múltiples entidades.
- **Domain Exceptions**: Excepciones de negocio (ej: `InsufficientFundsException`).
- **Ports (Interfaces)**: 
    - **Output Ports**: Definiciones de lo que el dominio necesita del mundo exterior (ej: `ProductRepositoryPort`, `NotificationPort`).
- **REGLA**: Dependencia CERO hacia frameworks (Spring, Hibernate). Solo POJOs/Data Classes.

### 2. Capa de Aplicación (`application`)
- **Input Ports (Interfaces)**: Definen qué puede hacer el sistema (ej: `CreateOrderUseCase`).
- **Use Cases (Implementation)**: Orquestan entidades y puertos de salida.
- **DTOs de Aplicación**: Objetos de transferencia específicos para la entrada/salida de la lógica de negocio.
- **REGLA**: No contiene lógica de negocio compleja, solo orquestación.

### 3. Capa de Infraestructura (`infrastructure`)
- **Driving Adapters (Input)**: Adaptadores que inician acciones (Controladores REST, Listeners de MQ, CLI).
- **Driven Adapters (Output)**: Implementaciones técnicas de los `Output Ports` (JPA Repositories, Clientes Feign, Adaptadores de Mail).
- **Mappers**: Convierten entre modelos de infraestructura (DTOs, Entity) y modelos de dominio.

## Mejores Prácticas

### Independencia del Dominio
- El dominio **NUNCA** debe usar anotaciones de JPA (`@Entity`, `@Table`) ni de Jackson (`@JsonProperty`).
- Si una entidad de dominio necesita ser persistida, debe existir una `Entity` separada en infraestructura y un `Mapper` que realice la conversión.

### Nomenclatura de Puertos
- **Input (Driving)**: `UseCase` (ej: `ProcessPaymentUseCase`).
- **Output (Driven)**: `Port` (ej: `PaymentGatewayPort`).

### Inyección de Dependencias
- Usar **Inyección por Constructor** siempre.
- Los beans de aplicación y dominio no deben usar `@Service` o `@Component` de Spring (para mantener el dominio puro). Se deben registrar mediante una clase `@Configuration` en la capa de infraestructura.

### Manejo de Errores
- Las excepciones de dominio deben ser capturadas en la capa de infraestructura por un `GlobalExceptionHandler` (ver `rest-error-response-standards`) para transformarlas en respuestas HTTP adecuadas.

### Auditoría y Soft Delete
- Aplicar los estándares de `jpa-stack` y `postgresql-standard` exclusivamente en los adaptadores de salida de persistencia. El dominio solo debe saber que los datos se guardan o recuperan.
