---
name: hexagonal-architecture
description: Implementación de Puertos y Adaptadores (Clean Architecture) con dominio puro, boundaries explícitos y desacoplamiento de frameworks.
---

# Arquitectura Hexagonal (Puertos y Adaptadores)

Guía para implementar una arquitectura limpia que protege la lógica de negocio de cambios tecnológicos. Esta skill define boundaries arquitectónicos; las convenciones de framework/lenguaje pertenecen a skills como `springboot-stack`, `java-stack`, `kotlin-stack`, `fastapi-stack`, `nodejs-stack` o `react-stack`.

## Estructura de Paquetes y Responsabilidades

### 1. Núcleo de Dominio (`domain`)
- **Entidades**: Objetos con identidad propia que contienen lógica de negocio.
- **Value Objects**: Objetos inmutables por valor (ej: `Email`, `Price`).
- **Domain Services**: Lógica que involucra múltiples entidades.
- **Domain Exceptions**: Excepciones de negocio (ej: `InsufficientFundsException`).
- **Domain Events**: Hechos de negocio ya ocurridos, sin semántica de infraestructura.
- **REGLA**: Dependencia CERO hacia frameworks, persistencia, transporte, UI, colas, HTTP, JSON, ORM o librerías de infraestructura.
- El dominio puede definir contratos de negocio puros cuando sean parte del lenguaje del dominio, pero los puertos técnicos suelen vivir en `application`.

### 2. Capa de Aplicación (`application`)
- **Input Ports (Interfaces)**: Definen qué puede hacer el sistema (ej: `CreateOrderUseCase`).
- **Use Cases (Implementation)**: Orquestan entidades, reglas de aplicación, transacciones conceptuales y puertos de salida.
- **Output Ports (Interfaces)**: Definen lo que la aplicación necesita del exterior (ej: `ProductRepositoryPort`, `NotificationPort`, `PaymentGatewayPort`).
- **Commands / Queries / Results**: Modelos de entrada/salida de caso de uso, independientes de HTTP, DB o UI.
- **REGLA**: No contiene detalles de framework ni infraestructura. Puede contener reglas de aplicación, pero la lógica de negocio central debe permanecer en dominio.

### 3. Capa de Infraestructura (`infrastructure`)
- **Driving Adapters (Input)**: Adaptadores que inician acciones (Controladores REST, Listeners de MQ, CLI).
- **Driven Adapters (Output)**: Implementaciones técnicas de los `Output Ports` (JPA Repositories, Clientes Feign, Adaptadores de Mail).
- **Mappers**: Convierten entre modelos de infraestructura (DTOs, Entity) y modelos de dominio.
- **Configuration / Wiring**: Registra dependencias concretas, transacciones técnicas, clientes externos, config y beans/providers.
- **REGLA**: La infraestructura depende de aplicación/dominio; dominio y aplicación no dependen de infraestructura.

## Dirección de Dependencias
- `domain` no depende de ninguna otra capa.
- `application` depende de `domain`.
- `infrastructure` depende de `application` y `domain`.
- `frontend`, `controllers`, `workers`, `jobs`, `n8n workflows` o `CLI` son driving adapters, no dueños de reglas de negocio.
- Los driven adapters implementan output ports definidos por aplicación.

## Mejores Prácticas

### Independencia del Dominio
- El dominio **NUNCA** debe usar anotaciones de JPA (`@Entity`, `@Table`) ni de Jackson (`@JsonProperty`).
- Si una entidad de dominio necesita ser persistida, debe existir una `Entity` separada en infraestructura y un `Mapper` que realice la conversión.
- El dominio no debe recibir DTOs de API, request objects, response objects, ORM entities, framework contexts, HTTP status, headers, claims técnicos ni objetos de infraestructura.
- El dominio debe expresar invariantes con métodos y Value Objects, no con validaciones dispersas en controllers/adapters.

### Nomenclatura de Puertos
- **Input (Driving)**: `UseCase` (ej: `ProcessPaymentUseCase`).
- **Output (Driven)**: `Port` (ej: `PaymentGatewayPort`).
- Los nombres de puertos deben expresar capacidad de negocio, no tecnología. Preferir `PaymentGatewayPort` sobre `StripeClientPort` salvo que el proveedor sea parte explícita del dominio.
- **Aclaración Go**: En Go, se permite omitir el sufijo `Port` en las interfaces (ej: usar `ProductRepository` o `PaymentGateway`) si estas residen físicamente en el paquete `application/ports`, manteniendo la pureza idiomática del lenguaje.
- **Aclaración Python**: Las interfaces se definen mediante clases abstractas (`abc.ABC`) o protocolos (`typing.Protocol`), y se les puede omitir el sufijo `Port` si están ubicadas en el paquete `application/ports`.

### Inyección de Dependencias
- Usar **Inyección por Constructor** siempre.
- El dominio no debe usar contenedor de dependencias.
- En stacks con DI, el wiring técnico pertenece a infraestructura o configuración de framework. En Go, la inyección es explícita por constructor en el punto de entrada `main.go`. En Python/FastAPI, se prohíbe usar `Depends` en la capa de aplicación o dominio; se usa `Depends` solo en los routers de la API para instanciar/inyectar las clases vía constructor clásico.
- Las reglas específicas sobre `@Service`, `@Component`, providers, modules o decorators pertenecen a la skill del stack activo.

### Manejo de Errores
- Las excepciones de dominio deben ser capturadas en la capa de infraestructura por un `GlobalExceptionHandler` o equivalente (ver la skill de error response del stack activo) para transformarlas en respuestas HTTP adecuadas.
- Las excepciones o errores de dominio deben expresar lenguaje de negocio.
- **Aclaración Go**: Dado que Go no maneja excepciones, las "excepciones de dominio" se implementan como errores centinela (`errors.New`) en la capa de dominio. Los adaptadores de entrada (`driving adapters`) deben capturarlos y realizar la traducción a códigos HTTP correspondientes mediante `errors.Is`.
- **Aclaración Python**: Las excepciones de dominio deben heredar de la clase base `Exception` pura de Python, sin dependencias de frameworks. Queda estrictamente prohibido lanzar `HTTPException` o usar códigos HTTP dentro de la lógica de dominio o aplicación. La traducción ocurre en handlers globales registrados en FastAPI.
- La traducción a HTTP, gRPC, eventos, jobs o UI errors ocurre en adapters.
- No filtrar errores técnicos hacia dominio ni convertir business errors en excepciones genéricas sin semántica.

### Auditoría y Soft Delete
- Aplicar los estándares de `jpa-stack` y `postgresql-standard` exclusivamente en los adaptadores de salida de persistencia. El dominio solo debe saber que los datos se guardan o recuperan.

### Mapeo Entre Capas
- Los mappers viven en application o infrastructure según el origen/destino, nunca dentro del dominio puro.
- Java puede usar MapStruct como estándar según `java-stack`.
- Kotlin debe preferir capacidades del lenguaje y usar MapStruct solo cuando lo justifique `kotlin-stack`.
- **Aclaración Python**: No se deben usar modelos `pydantic.BaseModel` como entidades de dominio si hay comportamiento. Tampoco existe un mapper automático estándar; se usan funciones de mapeo explícitas y testeadas en los adaptadores correspondientes.
- Los DTOs de transporte no deben cruzar hacia dominio.

## Reglas de Bloqueo
- Bloquear si dominio depende de framework, ORM, HTTP, JSON, cola, DB o UI.
- Bloquear si controller/adapter contiene lógica de negocio que pertenece a use case o dominio.
- Bloquear si repository/entity se usa directamente como modelo de dominio.
- Bloquear si un use case llama directamente a un cliente externo sin output port.
- Bloquear si una decisión de arquitectura requiere elegir boundaries nuevos sin Planner.

## Checklist Para Planner / Executor / Reviewer
- ¿Dónde vive la regla de negocio?
- ¿Qué input port/use case expone la capacidad?
- ¿Qué output ports necesita la aplicación?
- ¿Qué adapters implementan esos ports?
- ¿Qué modelos cruzan boundaries?
- ¿Dónde se mapean DTO/entity/domain/result?
- ¿Dónde se manejan transacciones, errores, retries, observability y seguridad?
- ¿El dominio puede probarse sin framework ni infraestructura?
