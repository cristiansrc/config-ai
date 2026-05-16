---
name: design-patterns-standard
description: Catálogo y guía de aplicación de patrones de diseño GoF en arquitecturas modernas (Java, Python, JS/TS).
---

# Estándares de Patrones de Diseño

Guía para la selección y aplicación de patrones de diseño clásicos adaptados a stacks modernos y Arquitectura Hexagonal.

## 1. Patrones Creacionales (Creational)
*Objetivo: Cómo se crean los objetos, abstrayendo la instanciación.*

- **Factory Method**: Usar para desacoplar la creación de objetos de dominio cuando la implementación depende de una configuración (ej: diferentes proveedores de pago).
- **Builder**: Mandatorio para objetos con muchos atributos opcionales (ej: Entities, DTOs complejos). En Java usar Lombok `@Builder`; en Python usar Pydantic.
- **Singleton**: En Spring Boot, es el scope por defecto de los `@Bean`. En Python, gestionar mediante la inyección de dependencias de FastAPI (`Depends`).

## 2. Patrones Estructurales (Structural)
*Objetivo: Cómo se componen las clases y objetos para formar estructuras mayores.*

- **Adapter**: Es el corazón de la Arquitectura Hexagonal. Usar para conectar Puertos (Interfaces) con tecnologías externas (BBDD, APIs).
- **Decorator**: Usar para añadir responsabilidades (logging, caching, validación) de forma dinámica sin modificar la clase base.
- **Proxy**: Usar para control de acceso o carga perezosa (Lazy Loading). Hibernate usa proxies por defecto.
- **Facade**: Proporcionar una interfaz simplificada a un subsistema complejo (ej: un Service de Aplicación que orquesta múltiples servicios de dominio).

## 3. Patrones de Comportamiento (Behavioral)
*Objetivo: Cómo se comunican y distribuyen las responsabilidades entre objetos.*

- **Strategy**: Usar para definir una familia de algoritmos e intercambiarlos en tiempo de ejecución (ej: diferentes estrategias de cálculo de impuestos).
- **Observer**: Usar para implementar sistemas de eventos o notificaciones desacoplados (ej: Spring Events, RxJS en Angular).
- **Command**: Encapsular una petición como un objeto, permitiendo parametrizar clientes con diferentes peticiones (útil para sistemas de tareas/jobs).
- **Template Method**: Definir el esqueleto de un algoritmo en una operación, delegando algunos pasos a las subclases.

## Aplicación por Stack

### Spring Boot (Java/Kotlin)
- **Dependency Injection**: Es la forma principal de aplicar patrones como Singleton, Strategy y Factory.
- **AOP (Aspect Oriented Programming)**: Forma idiomática de aplicar el patrón **Proxy/Decorator** para logging, seguridad y transacciones.

### FastAPI (Python)
- **Depends**: Sistema de inyección que permite aplicar **Strategy** y **Singleton** de forma limpia.
- **Protocols/ABCs**: Usar para definir interfaces y aplicar el patrón **Adapter**.

### Frontend (React/Angular)
- **Hooks (React)**: Funcionan como patrones **Strategy** y **State** para la lógica del componente.
- **Services/DI (Angular)**: Implementación nativa de **Singleton** y **Observer** (via RxJS).
- **Higher-Order Components (HOC)**: Patrón **Decorator** para componentes.

## Reglas de Oro
- **No sobre-arquitecturar**: Aplicar un patrón solo cuando resuelva un problema real de flexibilidad o mantenimiento.
- **Independencia del Dominio**: Los patrones estructurales complejos (como Proxy o Decorator técnicos) pertenecen a la capa de **Infraestructura**.
- **Naming**: Si un patrón es evidente, reflejarlo en el nombre de la clase (ej: `PaymentStrategy`, `EmailAdapter`, `OrderBuilder`).
