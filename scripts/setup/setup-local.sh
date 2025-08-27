#!/bin/bash

# Script de configuração local para o laboratório de IA Multiagentes

echo "🚀 Configurando o laboratório de IA Multiagentes..."

# Verificar se o Azure CLI está instalado
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI não encontrado. Por favor, instale o Azure CLI primeiro."
    exit 1
fi

# Verificar se o usuário está logado no Azure
if ! az account show &> /dev/null; then
    echo "🔐 Fazendo login no Azure..."
    az login
fi

# Instalar dependências Python
echo "📦 Instalando dependências Python..."
pip install -r src/tests/requirements.txt

# Executar testes
echo "🧪 Executando testes..."
pytest src/tests/

echo "✅ Configuração local concluída!"

