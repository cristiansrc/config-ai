---
name: enterprise-architecture-standard
description: Estándares para el diseño de macro-arquitectura, ecosistemas de microservicios y mapas de sistemas (Basado en Modelo C4 y DDD).
---

# Estándares de Arquitectura de Sistemas (Macro-Arquitectura)

Guía para definir la visión global del ecosistema, las fronteras de los servicios y la interacción entre componentes de alto nivel.

## 1. Visión del Ecosistema (System Landscape)
Toda solución debe estar documentada siguiendo los niveles del **Modelo C4**:
- **Nivel 1: Contexto**: Diagrama del sistema completo, sus usuarios y las dependencias externas (ej: Pasarelas de pago, Proveedores de SMS).
- **Nivel 2: Contenedores**: Mapa de aplicaciones individuales (Microservicios, SPAs, Mobile Apps, Bases de Datos).
- **Nivel 3: Componentes**: (Se delega a `hexagonal-architecture` por proyecto).

## 2. Definición de Fronteras (Bounded Contexts)
Siguiendo **Domain-Driven Design (DDD)**:
- Cada microservicio debe representar un único Contexto Delimitado.
- Evitar las "Entidades Dios" compartidas entre servicios. Cada servicio tiene su propia versión del modelo.
- **Context Mapping**: Definir la relación entre servicios (Upstream/Downstream, Customer-Supplier, Anti-Corruption Layer).

## 3. Patrones de Comunicación Global
- **Sincrónica**: REST/gRPC vía API Gateway (ver `spring-cloud-gateway`). Usar solo para operaciones que requieren respuesta inmediata.
- **Asincrónica**: Event-Driven Architecture (EDA) mediante Message Brokers (RabbitMQ, Kafka). Preferir para desacoplamiento y consistencia eventual.
- **Contratos Macro**: Antes de iniciar un proyecto, se debe definir el **Integration Contract** que especifica qué eventos produce/consume y qué APIs expone al ecosistema.

## 4. Servicios Transversales (Cross-Cutting Concerns)
- **Identidad**: Keycloak como proveedor único (ver `keycloak-standard`).
- **Observabilidad**: Centralización de trazas y logs (ver `observability-standard`).
- **Resiliencia**: Estrategias globales de reintentos y Circuit Breakers.

## 5. El Manifiesto de Arquitectura del Sistema
Cada ecosistema debe tener un archivo `docs/architecture/system-landscape.md` que contenga:
- Mapa de servicios activos.
- Flujos de datos críticos de extremo a extremo (E2E flows).
- Matriz de dependencias entre repositorios.
- Diccionario de términos compartidos (Ubiquitous Language).

## 6. Estructura de Solution Workspace
Para gestionar múltiples repositorios bajo una única visión de arquitectura:
- **Carpeta `proyectos/`**: Ubicada en la raíz del repositorio de arquitectura enterprise.
- **Git Isolation**: El archivo `.gitignore` de la raíz DEBE contener la entrada `proyectos/*` para que cada proyecto mantenga su propio repositorio independiente.
- **Descubrimiento**: Los agentes deben ser capaces de navegar a `proyectos/<repo-name>` para leer código, pero los cambios operativos se limitan al repositorio del proyecto actual.
- **Mapeo de Workspace**: El `system-landscape.md` debe incluir una sección `## Workspace Mapping` con las rutas relativas de cada servicio.

## Reglas de Oro
- **Búsqueda Jerárquica**: Si un agente está trabajando dentro de un proyecto en la carpeta `proyectos/`, DEBE buscar specs generales (Master Spec de solución) en el nivel superior (`../../docs/architecture/`).
- **Desacoplamiento Máximo**: Un fallo en un microservicio no debe tumbar el ecosistema (Bulkheading).
- **Contrato Primero**: No se crea un servicio sin antes validar su interfaz con el `enterprise-architect`.
