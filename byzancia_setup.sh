bash -c 'cat > byzancia_setup.sh << "EOF"
#!/usr/bin/env bash
set -euo pipefail

# =========
# Config
# =========
BASE_DIR="$HOME/byzancia_ibax_setup"
SCRIPTS_DIR="$BASE_DIR/scripts"
SYSTEMD_DIR="$BASE_DIR/systemd"
CONFIG_DIR="$BASE_DIR/config"
CONTRACTS_DIR="$BASE_DIR/contracts"

mkdir -p "$SCRIPTS_DIR" "$SYSTEMD_DIR" "$CONFIG_DIR" "$CONTRACTS_DIR"

# =========
# README
# =========
cat > "$BASE_DIR/README_IBAX_SETUP.md" << "EORD"
# IBAX (go-ibax) – Setup de nodo local (Fase I)
Este paquete contiene scripts y archivos de apoyo para instalar y arrancar un nodo local de IBAX (go-ibax) en Ubuntu.
**Ajusta rutas y parámetros según tu entorno.**

## Contenido
- `scripts/install_ibax.sh`: instala Go, PostgreSQL y dependencias; clona y compila `go-ibax`.
- `scripts/init_ibax.sh`: inicializa el nodo (config, llaves, primer bloque, DB).
- `scripts/start_ibax.sh` y `scripts/stop_ibax.sh`: arrancar/detener.
- `systemd/ibax.service`: servicio opcional para autoarranque.
- `config/env.sample`: variables de entorno (GO + IBAX).
- `config/postgres.sql`: crea usuario/DB de PostgreSQL.
- `contracts/tokens_spec.md`: plantilla para especificar JSD, JSDV, TCC, BCC, FLIP.

> NOTA: Cambia contraseñas, rutas y versiones de Go según tu preferencia.
EORD

# =========
# scripts/install_ibax.sh
# =========
cat > "$SCRIPTS_DIR/install_ibax.sh" << "EORD"
#!/usr/bin/env bash
set -euo pipefail

# === Variables ===
GO_VERSION="${GO_VERSION:-1.22.6}"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"
IBAX_DIR="${IBAX_DIR:-$HOME/ibax}"
REPO_URL="${REPO_URL:-https://github.com/IBAX-io/go-ibax}"
DB_USER="${DB_USER:-ibax}"
DB_PASS="${DB_PASS:-ibaxpwd}"
DB_NAME="${DB_NAME:-ibax}"

echo "[1/6] Actualizando paquetes..."
sudo apt-get update -y
sudo apt-get install -y build-essential git curl wget tar ca-certificates \
  postgresql postgresql-contrib pkg-config

echo "[2/6] Instalando Go ${GO_VERSION} ..."
if [ -d /usr/local/go ]; then
  sudo rm -rf /usr/local/go
fi
wget -q "${GO_URL}"
sudo tar -C /usr/local -xzf "${GO_TARBALL}"
rm -f "${GO_TARBALL}"

if ! grep -q "export PATH=/usr/local/go/bin:\$PATH" "$HOME/.bashrc"; then
  echo 'export PATH=/usr/local/go/bin:$PATH' >> "$HOME/.bashrc"
fi
export PATH=/usr/local/go/bin:$PATH

echo "[3/6] Configurando PostgreSQL..."
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 || \
  sudo -u postgres psql -c "CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASS}';"
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1 || \
  sudo -u postgres createdb -O ${DB_USER} ${DB_NAME}

echo "[4/6] Clonando repositorio IBAX..."
mkdir -p "${IBAX_DIR}"
if [ ! -d "${IBAX_DIR}/.git" ]; then
  git clone "${REPO_URL}" "${IBAX_DIR}"
else
  (cd "${IBAX_DIR}" && git pull --ff-only)
fi

echo "[5/6] Compilando go-ibax..."
cd "${IBAX_DIR}"
go mod tidy -v
go build

echo "[6/6] Variables de entorno para IBAX"
if ! grep -q "export IBAX_DB_CONN=" "$HOME/.bashrc"; then
  echo "export IBAX_DB_CONN=\"host=localhost port=5432 user=${DB_USER} password=${DB_PASS} dbname=${DB_NAME} sslmode=disable\"" >> "$HOME/.bashrc"
fi

echo "Instalación completada. Abre una nueva terminal o ejecuta: source ~/.bashrc"
EORD

# =========
# scripts/init_ibax.sh
# =========
cat > "$SCRIPTS_DIR/init_ibax.sh" << "EORD"
#!/usr/bin/env bash
set -euo pipefail
IBAX_DIR="${IBAX_DIR:-$HOME/ibax}"
cd "${IBAX_DIR}"

echo "[1/4] Generando configuración"
./go-ibax config

echo "[2/4] Generando llaves"
./go-ibax generateKeys

echo "[3/4] Generando primer bloque (modo test)"
./go-ibax generateFirstBlock --test=true

echo "[4/4] Inicializando base de datos"
./go-ibax initDatabase

echo "Inicialización completada. Puedes arrancar el nodo con scripts/start_ibax.sh"
EORD

# =========
# scripts/start_ibax.sh
# =========
cat > "$SCRIPTS_DIR/start_ibax.sh" << "EORD"
#!/usr/bin/env bash
set -euo pipefail
IBAX_DIR="${IBAX_DIR:-$HOME/ibax}"
mkdir -p "${IBAX_DIR}/logs"
cd "${IBAX_DIR}"
echo "Arrancando go-ibax..."
./go-ibax start | tee -a "${IBAX_DIR}/logs/ibax.log"
EORD

# =========
# scripts/stop_ibax.sh
# =========
cat > "$SCRIPTS_DIR/stop_ibax.sh" << "EORD"
#!/usr/bin/env bash
set -euo pipefail
echo "Deteniendo go-ibax (si está en ejecución)..."
pkill -f "go-ibax start" || true
EORD

# =========
# systemd/ibax.service
# =========
cat > "$SYSTEMD_DIR/ibax.service" << "EORD"
[Unit]
Description=IBAX (go-ibax) Node
After=network.target postgresql.service

[Service]
Type=simple
User=%i
WorkingDirectory=/home/%i/ibax
ExecStart=/home/%i/ibax/go-ibax start
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EORD

# =========
# config/env.sample
# =========
cat > "$CONFIG_DIR/env.sample" << "EORD"
# Añadir al ~/.bashrc (o exportar antes de ejecutar los scripts)
export PATH=/usr/local/go/bin:$PATH
export IBAX_DB_CONN="host=localhost port=5432 user=ibax password=ibaxpwd dbname=ibax sslmode=disable"
# Variables opcionales
# export IBAX_DIR="$HOME/ibax"
# export GO_VERSION="1.22.6"
EORD

# =========
# config/postgres.sql
# =========
cat > "$CONFIG_DIR/postgres.sql" << "EORD"
-- Cambia contraseñas y nombres según tu preferencia
CREATE ROLE ibax LOGIN PASSWORD 'ibaxpwd';
CREATE DATABASE ibax OWNER ibax;
GRANT ALL PRIVILEGES ON DATABASE ibax TO ibax;
EORD

# =========
# contracts/tokens_spec.md
# =========
cat > "$CONTRACTS_DIR/tokens_spec.md" << "EORD"
# Especificación de Tokens – Fase I (Byzancia Exchange)

| Token | Nombre completo                  | Símbolo | Decimales | Supply inicial | Emisión | Quema | Roles/Permisos |
|------:|----------------------------------|---------|-----------|----------------|---------|-------|----------------|
| 1     | Jerusalén Solar Dólar            | JSD     | 18        | 0 (mint bajo demanda) | mint: Consejo | burn: Consejo | Consejo (mint/burn), Guardián (audita) |
| 2     | Jerusalén Solar Dólar Verde      | JSDV    | 18        | 0 | mint: Consejo | burn: Consejo | Consejo; proyectos verdes |
| 3     | Templar Caem Coin                | TCC     | 18        | 0 | mint: Consejo | burn: Consejo | Consejo; subastas |
| 4     | Byzancia Caem Coin               | BCC     | 18        | 0 | mint: Consejo | burn: Consejo | Consejo; comercio interno |
| 5     | FLIP (testimonio ceremonial)     | FLIP    | 18        | 0 | mint: Consejo | burn: Auto (uso en servicios) | Acceso TV/DAO/Recompensas |

> Ajusta: supply, decimales y políticas definitivas. Documenta cuentas con permisos y bóveda de claves.
EORD

# =========
# Permisos y salida
# =========
chmod +x "$SCRIPTS_DIR/"*.sh
echo "✅ Paquete creado en: $BASE_DIR"
echo "Siguiente paso:"
echo "  1) Ejecutar: $SCRIPTS_DIR/install_ibax.sh"
echo "  2) Luego:    $SCRIPTS_DIR/init_ibax.sh"
echo "  3) Arrancar: $SCRIPTS_DIR/start_ibax.sh"
EOF
chmod +x byzancia_setup.sh
./byzancia_setup.sh'
