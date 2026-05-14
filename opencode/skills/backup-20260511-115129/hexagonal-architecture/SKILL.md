---
name: hexagonal-architecture
description: Implementación de Puertos y Adaptadores en Spring Boot (Java/Kotlin) con Gradle.
---

# Arquitectura Hexagonal (Puertos y Adaptadores)

Implementación de una arquitectura limpia que desacopla la lógica de negocio de los detalles técnicos y frameworks.

## Estructura de Capas

### 1. Dominio (`domain`)
- **Contenido**: Entidades de dominio, Objetos de Valor (Value Objects), Servicios de Dominio e Interfaces de Puertos (Ports).
- **Regla de Oro**: Cero dependencias de frameworks (Spring, JPA, etc.) o librerías externas de infraestructura. Contiene la lógica de negocio pura.

### 2. Aplicación (`application`)
- **Contenido**: Casos de uso y servicios de aplicación.
- **Responsabilidad**: Orquestar el dominio para ejecutar tareas específicas del negocio. Define qué debe suceder, pero no cómo se accede a los datos o se exponen.

### 3. Infraestructura (`infrastructure`)
- **Contenido**: Adaptadores de entrada y salida.
    - **Entrada**: Controladores Web (que implementan interfaces OpenAPI).
    - **Salida**: Persistencia (Spring Data JPA), Clientes Externos (REST/gRPC), Mensajería.
- **Configuración**: Se requiere inyección por constructor obligatoria para todos los componentes.

## Mapeo y Datos
- **Conversión entre Capas**:
    - **Java**: Uso de MapStruct para transformar entre API DTO -> Dominio -> Entidad de Persistencia.
    - **Kotlin**: Uso de funciones de extensión o Data Classes para el mapeo.
- **Persistencia**: El esquema de base de datos se valida con `hibernate.ddl-auto=validate`. El esquema debe ser gestionado exclusivamente por herramientas de migración.
