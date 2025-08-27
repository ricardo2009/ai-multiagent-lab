#!/bin/bash

# Script de deploy para Azure

echo "🚀 Iniciando deploy para Azure..."

# Verificar se o usuário está logado no Azure
if ! az account show &> /dev/null; then
    echo "❌ Você precisa estar logado no Azure. Execute 'az login' primeiro."
    exit 1
fi

# Provisionar infraestrutura com Bicep
echo "🏗️ Provisionando infraestrutura com Bicep..."
az deployment sub create \
    --location eastus \
    --template-file ./infrastructure/bicep/main.bicep \
    --parameters location=eastus resourceGroupName=ai-multiagent-lab-rg

echo "✅ Deploy concluído!"

