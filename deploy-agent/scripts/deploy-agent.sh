#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DB_RG="my-db-rg"
MYSQL_SERVER="my-mysql-serversad2eda3ead"
ADMIN_USER="azureuser"
MYSQL_VERSION="8.0.23"
MYSQL_DB="stomology_dep"
DB_HOST="my-mysql-serversad2eda3ead.mysql.database.azure.com"  

REPO_URL="https://github.com/michaelcriss-dev/fullstack-app.git"

APP_RG="my-app-rg"
PLAN_NAME="plan-name-asd2dawdawwdw"
SKU="B1"
WEB_APP_NAME="my-web-app-3434323423"
DOCKER_IMAGE="michael2209/fullstack-app:v1.0"
LOCATION="Canada Central"


# Azure Login

az login --service-principal \
    -u "$ARM_CLIENT_ID" \
    -p "$ARM_CLIENT_SECRET" \
    --tenant "$ARM_TENANT_ID"


# Crear Resource Group para DB

az group create --name "${DB_RG}" --location "${LOCATION}"


# Crear MySQL Flexible Server

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

# Clonar o actualizar repositorio
git clone $REPO_URL


# Importar base de datos si no existe

export MYSQL_PWD="$ADMIN_PASSWORD"

cd fullstack/SQL
if ! mysql -h "${DB_HOST}" -u "${ADMIN_USER}" -e "USE ${MYSQL_DB};" 2>/dev/null; then
    echo "Importing DB..."
    mysql -h "${DB_HOST}" -u "${ADMIN_USER}" -e "CREATE DATABASE ${MYSQL_DB};"
    mysql -h "${DB_HOST}" -u "${ADMIN_USER}" "${MYSQL_DB}" < ./stomology_dep.sql
else
    echo "Database already exists..."
fi

unset MYSQL_PWD


# Crear Resource Group para Web App

az group create --name "${APP_RG}" --location "${LOCATION}"


# Crear App Service Plan
az appservice plan create \
  --name "${PLAN_NAME}" \
  --resource-group "${APP_RG}" \
  --location "${LOCATION}" \
  --is-linux \
  --sku "${SKU}"


# Crear Web App y desplegar imagen Docker
az webapp create \
  --resource-group "${APP_RG}" \
  --plan "${PLAN_NAME}" \
  --name "${WEB_APP_NAME}" \
  --deployment-container-image-name "${DOCKER_IMAGE}"


# Configurar variables de entorno de la Web App
az webapp config appsettings set \
  --resource-group "${APP_RG}" \
  --name "${WEB_APP_NAME}" \
  --settings \
    DB_HOST="${DB_HOST}" \
    DB_USER="${ADMIN_USER}" \
    DB_PASSWORD="${ADMIN_PASSWORD}"

echo "Deployment complete!"
