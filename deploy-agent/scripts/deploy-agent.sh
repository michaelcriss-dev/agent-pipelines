#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DB_RG="my-db-rg"
MYSQL_SERVER="my-mysql-serversad2eda3ead"
ADMIN_USER="azureuser"
ADMIN_USER_FULL="${ADMIN_USER}@${MYSQL_SERVER}"
MYSQL_VERSION="8.0.21"
MYSQL_DB="stomology_dep"
DB_HOST="my-mysql-serversad2eda3ead.mysql.database.azure.com"  

REPO_URL="https://github.com/michaelcriss-dev/fullstack-app.git"

APP_RG="my-app-rg"
PLAN_NAME="plan-name-asd2dawdawwdw"
SKU="B1"
WEB_APP_NAME="my-web-app-3434323423"
DOCKER_IMAGE="michael2209/fullstack-app:v1.0"
LOCATION="Canada Central"

echo "Iniciando script de despliegue"

echo "Autenticando en Azure"
az login --service-principal \
    -u "$ARM_CLIENT_ID" \
    -p "$ARM_CLIENT_SECRET" \
    --tenant "$ARM_TENANT_ID"

echo "Creando Resource Group para DB"
az group create --name "${DB_RG}" --location "${LOCATION}"

echo "Creando MySQL Flexible Server"
az mysql flexible-server create \
  --name "${MYSQL_SERVER}" \
  --resource-group "${DB_RG}" \
  --location "${LOCATION}" \
  --admin-user "${ADMIN_USER}" \
  --admin-password "${ADMIN_PASSWORD}" \
  --sku-name Standard_B1ms \
  --version "${MYSQL_VERSION}" \
  --public-access 0.0.0.0-255.255.255.255

az mysql flexible-server firewall-rule create \
  --resource-group "${DB_RG}" \
  --name "${MYSQL_SERVER}" \
  --rule-name "AllowAzureServices" \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "Clonando repositorio"
git clone "$REPO_URL"
cd fullstack-app/SQL

echo "Importando base de datos"
export MYSQL_PWD="$ADMIN_PASSWORD"
if ! mysql -h "${DB_HOST}" -u "${ADMIN_USER_FULL}" --silent --skip-column-names -e "USE ${MYSQL_DB};" 2>/dev/null; then
    mysql -h "${DB_HOST}" -u "${ADMIN_USER_FULL}" -e "CREATE DATABASE ${MYSQL_DB};"
    mysql -h "${DB_HOST}" -u "${ADMIN_USER_FULL}" "${MYSQL_DB}" < stomology_dep.sql
else
    echo "Database already exists"
fi
unset MYSQL_PWD

echo "Creando Resource Group para App"
az group create --name "${APP_RG}" --location "${LOCATION}"

echo "Creando App Service Plan"
az appservice plan create \
  --name "${PLAN_NAME}" \
  --resource-group "${APP_RG}" \
  --location "${LOCATION}" \
  --is-linux \
  --sku "${SKU}"

echo "Creando Web App y desplegando imagen Docker"
az webapp create \
  --resource-group "${APP_RG}" \
  --plan "${PLAN_NAME}" \
  --name "${WEB_APP_NAME}" \
  --deployment-container-image-name "${DOCKER_IMAGE}"

echo "Configurando variables de entorno"
az webapp config appsettings set \
  --resource-group "${APP_RG}" \
  --name "${WEB_APP_NAME}" \
  --settings \
    DB_HOST="${DB_HOST}" \
    DB_USER="${ADMIN_USER_FULL}" \
    DB_PASSWORD="${ADMIN_PASSWORD}"

echo "Despliegue completado"
