---
name: spring-cloud-gateway
description: Estándares y mejores prácticas para la implementación de API Gateways con Spring Cloud Gateway.
---

# Estándares Spring Cloud Gateway

Guía para la implementación de un Gateway como punto de entrada único a microservicios, restringido a enrutamiento, seguridad y cross-cutting concerns.

## Detección del Stack

- Si el archivo `build.gradle`, `build.gradle.kts` o `pom.xml` contiene la dependencia `spring-cloud-starter-gateway` o `spring-cloud-gateway-server`, este skill se considera **ACTIVO**.
- Si el proyecto usa Spring Cloud Gateway MVC (servlet-based), aplicar solo las secciones de configuración y seguridad; las secciones de WebFlux no aplican.

## Arquitectura y Responsabilidad

- El Gateway es un **adaptador de infraestructura** en términos de Arquitectura Hexagonal: su única responsabilidad es enrutamiento, filtrado, seguridad y cross-cutting concerns.
- **Prohibido** colocar lógica de negocio en el Gateway. Si se necesita orquestación de llamadas, pertenece a un BFF o servicio de aplicación, no al Gateway.
- **Prohibido** usar operaciones bloqueantes (JDBC, llamadas síncronas bloqueantes, `Thread.sleep`) si el Gateway usa WebFlux/Netty. Usar clientes reactivos (`WebClient`, `ReactiveRedisTemplate`).

## Enrutamiento y Configuración

- **Predicados**: Usar `Path` con versionado explícito en la ruta (ej: `/api/v1/orders/**`). Prohibir rutas sin versión.
- **Filtros de Ruta**:
    - `StripPrefix`: Usar cuando el prefijo del Gateway no debe llegar al servicio interno (ej: `StripPrefix=1` quita `/api/v1`).
    - `AddRequestHeader`: Inyectar cabeceras de trazabilidad (`X-Trace-Id`) y de seguridad.
- **Service Discovery**: Preferir `lb://service-name` con Eureka/Consul. Usar URLs estáticas (`http://host:port`) solo para servicios externos o entornos sin discovery.
- **Configuración**: Preferir archivos YAML sobre properties. Organizar rutas por perfil (`application.yml`, `application-dev.yml`, `application-prod.yml`).
- **Orden de Filtros**: Los filtros globales deben declarar `getOrder()` explícitamente. Orden canónico:
    1. `TraceIdFilter` (mayor prioridad, orden más bajo)
    2. `AuthenticationFilter` / `TokenRelay`
    3. `RateLimitFilter`
    4. `CircuitBreakerFilter`
    5. `LoggingFilter` (menor prioridad, orden más alto)

## Seguridad e Identidad

- **Token Relay**: Usar `TokenRelayGatewayFilterFactory` para propagar JWT de Keycloak hacia los microservicios. Ver `keycloak-standard`.
- **Validación de Token**: El Gateway valida firma y expiración del JWT; los microservicios validan claims y permisos.
- **CORS**: Configurar `corsConfigurations` global en el Gateway. Prohibir `@CrossOrigin` en microservicios downstream.
- **Rate Limiting**: Usar `RequestRateLimiter` con Redis como backend. Configurar rate limits por ruta y por tenant cuando aplique.

## Resiliencia y Rendimiento

- **Circuit Breaker**: Usar `Spring Cloud Circuit Breaker` con Resilience4j. Definir fallbacks para rutas críticas que retornen una respuesta estructurada de error (alineada con `springboot-java-rest-error-response-standards` o `springboot-kotlin-rest-error-response-standards`).
- **Retry**: Configurar `RetryGatewayFilterFactory` con máximo 3 intentos para operaciones idempotentes (`GET`). Prohibir retry en `POST`, `PUT`, `DELETE` a menos que el downstream sea idempotente por diseño.
- **Timeout**: Definir `connect-timeout` y `read-timeout` por ruta. Timeout global por defecto: 30s. Ajustar por servicio según SLA.
- **Request/Response Size**: Configurar límite de tamaño de payload (`spring.codec.max-in-memory-size`) para prevenir ataques de memoria.

## Observabilidad y Trazabilidad

- **Trace ID**: Usar `X-Trace-Id` como header canónico de trazabilidad, alineado con el campo `trace_id` del error response estándar del stack activo.
- **Correlation Filter**: Implementar un `GlobalFilter` que genere o propague `X-Trace-Id` en cada petición y respuesta.
- **Access Logs**: Configurar logs que incluyan: ruta origen, servicio destino, status code, tiempo de respuesta y trace ID.
- **Metrics**: Exponer métricas del Gateway mediante Actuator + Micrometer para Prometheus/Grafana. Ver `observability-standard`.

## Documentación Consolidada

- **OpenAPI Aggregation**: El Gateway expone un endpoint único (`/openapi.yaml` o `/swagger-ui.html`) que agrega los contratos OpenAPI de los microservicios registrados.
- Usar `springdoc-openapi-webflux-ui` con configuración de URLs de los microservicios downstream.
- El contrato agregado debe usar el mismo schema de errores REST declarado en `openapi-standard` y la skill de error response del stack activo.

## Pruebas y Cobertura

- **Herramientas**: JUnit 5, WebTestClient, Mockito, Testcontainers (para Redis si aplica).
- **Cobertura**: JaCoCo con umbral mínimo 85% por archivo testable.
- **Tests de rutas**: Verificar predicados, filtros y fallbacks con `WebTestClient.bindToRouterFunction`.
- **Tests de filtros globales**: Verificar orden de ejecución, propagación de headers y comportamiento con tokens inválidos.

## Comportamiento Obligatorio

1. Toda ruta debe tener versión explícita (`/api/v1/...`).
2. Toda ruta debe tener `read-timeout` configurado.
3. El Gateway debe propagar `X-Trace-Id` en todas las peticiones y respuestas.
4. La configuración de CORS debe ser global en el Gateway, no en los microservicios.