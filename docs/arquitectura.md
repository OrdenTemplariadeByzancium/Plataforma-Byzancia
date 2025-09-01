# Arquitectura de la Plataforma

## Visión general
La plataforma se organiza en módulos (`modules/`) y servicios (`services/`).

- **Módulos**: dominio funcional (ej. recompensas, token JSD).
- **Servicios**: aplicaciones ejecutables (API, Web, Worker).

## Flujo básico
- El usuario interactúa con **Web**.
- Web consume **API**.
- API consulta **DB** (Postgres) y cache (Redis).
- Worker procesa tareas en background.

## Infraestructura
- Contenedores orquestados con Docker Compose.
- Base de datos: PostgreSQL 16.
- Cache/mensajería: Redis 7.
- API/Worker: Go (go-ibax) o Node.js (según módulo).
- Web: Next.js/Vite.
