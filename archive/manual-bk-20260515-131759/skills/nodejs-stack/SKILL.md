# Skill: Node.js Stack Convention (IDIOMA: ESPAÑOL)

Este skill define las convenciones de rutas y arquitectura para proyectos Node.js (TypeScript) con Arquitectura Limpia.

## Estructura de Carpetas (Clean Architecture)
- **Domain**: `src/domain/` (Entidades y lógica de negocio pura).
- **Application**: `src/application/` (Casos de uso y orquestación).
- **Infrastructure**: `src/infrastructure/` (Implementaciones de DB, APIs externas, adaptadores).
- **Interfaces/Web**: `src/interfaces/http/` o `src/web/` (Controladores, rutas y middlewares).

## Convenciones de Rutas
- **OpenAPI Runtime**: `src/infrastructure/http/openapi.yaml` o según se defina en el shared context.
- **Config**: `src/config/` (Configuración de entorno y constantes).
- **Tests Root**: `tests/` (Estructura paralela a src) o junto al archivo (`.test.ts`).

## Comportamiento Obligatorio
1.  **Desacoplamiento**: El dominio NO debe importar nada de la infraestructura o del framework (Express/Fastify).
2.  **Sincronización**: El Executor debe sincronizar el OpenAPI desde `docs/api/` a la ruta de infraestructura configurada.
3.  **Validación**: Usar Zod o similar para validación de contratos en los puntos de entrada (DTOs).

## Detección del Stack
- Si `package.json` existe y NO contiene `react` ni `angular`, y el proyecto es de backend, este skill se considera **ACTIVO**.
