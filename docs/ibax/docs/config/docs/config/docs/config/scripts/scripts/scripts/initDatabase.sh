#!/usr/bin/env bash
set -euo pipefail

# === initDatabase.sh ===
# Inicializa la base de datos PostgreSQL para IBAX.

IBAX_BIN="${IBAX_BIN:-./ibax}"
# Ejemplo DSN; cámbialo para producción o pásalo por variable de entorno.
DSN="${DSN:-host=localhost user=postgres password=1234 dbname=ibax sslmode=disable}"

command -v "$IBAX_BIN" >/dev/null 2>&1 || {
  echo " No se encontró el binario: $IBAX_BIN"
  exit 1
}

echo "🗄️ Inicializando base de datos con DSN:"
echo "    $DSN"
"$IBAX_BIN" initDatabase --dsn "$DSN"

echo " Base de datos inicializada."
