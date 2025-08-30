#!/usr/bin/env bash
set -euo pipefail

# === generateFirstBlock.sh ===
# Crea el bloque génesis usando la llave pública generada previamente.

IBAX_BIN="${IBAX_BIN:-./ibax}"
KEYS_DIR="${KEYS_DIR:-./keys}"
PUBLIC_KEY="${PUBLIC_KEY:-$KEYS_DIR/public.key}"
GENESIS_DIR="${GENESIS_DIR:-./genesis}"

command -v "$IBAX_BIN" >/dev/null 2>&1 || {
  echo " No se encontró el binario: $IBAX_BIN"
  exit 1
}

[ -f "$PUBLIC_KEY" ] || {
  echo " No existe la llave pública: $PUBLIC_KEY"
  echo "   Ejecuta primero scripts/generateKeys.sh"
  exit 1
}

mkdir -p "$GENESIS_DIR"

echo " Creando bloque génesis..."
"$IBAX_BIN" generateFirstBlock --public-key="$PUBLIC_KEY"

# Si el binario crea un archivo de salida, muévelo a GENESIS_DIR (ajusta nombre si aplica)
[ -f firstblock.dat ] && mv -f firstblock.dat "$GENESIS_DIR/" || true

echo " Génesis listo en: $GENESIS_DIR"
ls -l "$GENESIS_DIR" || true
