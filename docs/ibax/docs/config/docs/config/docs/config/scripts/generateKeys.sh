#!/usr/bin/env bash
set -euo pipefail

# === generateKeys.sh ===
# Genera el par de llaves para IBAX y las guarda en ./keys

IBAX_BIN="${IBAX_BIN:-./ibax}"
KEYS_DIR="${KEYS_DIR:-./keys}"

command -v "$IBAX_BIN" >/dev/null 2>&1 || {
  echo " No se encontró el binario: $IBAX_BIN"
  echo "   Define IBAX_BIN o coloca el binario en la raíz como ./ibax"
  exit 1
}

mkdir -p "$KEYS_DIR"

echo " Generando llaves en $KEYS_DIR ..."
"$IBAX_BIN" generateKeys

# Mueve si el binario las dejó en otro directorio (ajusta si aplica)
[ -f public.key ] && mv -f public.key "$KEYS_DIR/" || true
[ -f private.key ] && mv -f private.key "$KEYS_DIR/" || true

echo " Listo. Llaves en: $KEYS_DIR"
ls -l "$KEYS_DIR" || true
