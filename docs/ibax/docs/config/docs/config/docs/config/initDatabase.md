docs/config/initDatabase.md
# initDatabase – Inicialización de la Base de Datos

Este archivo documenta cómo crear e inicializar la base de datos para IBAX.

## Ejemplo de uso
```bash
./ibax initDatabase --dsn "host=localhost user=postgres password=1234 dbname=ibax sslmode=disable"

Resultado

Se crea la base de datos llamada ibax.

Se generan las tablas iniciales necesarias para la blockchain.

El nodo queda listo para iniciar operaciones básicas.

Recomendaciones

Usa credenciales seguras para tu base de datos (no uses 1234 en producción).

Verifica que PostgreSQL esté corriendo antes de ejecutar el comando.

Haz una copia de seguridad después de la inicialización si es un nodo de producción.

---

Con esto completas la carpeta **`docs/config/`**.  

