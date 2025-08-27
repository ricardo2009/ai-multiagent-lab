#!/bin/bash

# Setup Local para Demonstração - Aplicações Inteligentes com Azure
# Configuração rápida e otimizada para apresentações técnicas

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo "║    🤖 APLICAÇÕES INTELIGENTES COM AZURE: SETUP LOCAL                        ║"
    echo "║                                                                              ║"
    echo "║    Configuração rápida para demonstração técnica                            ║"
    echo "║    Azure AI Foundry + Copilot Studio + Arquitetura Moderna                  ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Função para log com timestamp
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] ⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ❌ $1${NC}"
}

log_info() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] ℹ️  $1${NC}"
}

# Verificar se está no diretório correto
check_directory() {
    if [[ ! -f "README.md" ]] || [[ ! -d "src" ]]; then
        log_error "Execute este script a partir do diretório raiz do projeto ai-multiagent-lab"
        exit 1
    fi
}

# Verificar dependências do sistema
check_dependencies() {
    log "🔍 Verificando dependências do sistema..."
    
    local missing_deps=()
    
    # Python 3.9+
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    fi
    
    # Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Azure CLI (opcional para demo local)
    if ! command -v az &> /dev/null; then
        log_warning "Azure CLI não encontrado - algumas funcionalidades podem estar limitadas"
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Dependências faltando: ${missing_deps[*]}"
        log_info "Instale as dependências e execute novamente"
        exit 1
    fi
    
    log "✅ Todas as dependências verificadas"
}

# Configurar ambiente Python
setup_python_environment() {
    log "🐍 Configurando ambiente Python..."
    
    # Instalar dependências principais
    log "Instalando dependências Python..."
    
    # Instalar dependências dos testes
    if [[ -f "src/tests/requirements.txt" ]]; then
        pip3 install -r src/tests/requirements.txt > /dev/null 2>&1
    fi
    
    log "✅ Ambiente Python configurado"
}

# Configurar variáveis de ambiente para demo
setup_demo_environment() {
    log "🔧 Configurando variáveis de ambiente para demonstração..."
    
    # Criar arquivo .env para demo local
    cat > .env << EOF
# Configurações para Demonstração Local
ENVIRONMENT=demo
DEBUG=true
LOG_LEVEL=info

# Simulação de Azure AI Foundry
AZURE_AI_FOUNDRY_ENDPOINT=https://demo-ai-foundry.azure.com
AZURE_AI_FOUNDRY_KEY=demo_key_for_presentation

# Simulação de Copilot Studio
COPILOT_STUDIO_ENDPOINT=https://demo-copilot.microsoft.com
COPILOT_STUDIO_KEY=demo_copilot_key

# Configurações de Demo
DEMO_MODE=true
DEMO_RESPONSE_DELAY=2000
DEMO_SUCCESS_RATE=100
DEMO_AGENT_COUNT=4

# Métricas simuladas
METRICS_ENABLED=true
METRICS_ENDPOINT=http://localhost:3001/metrics

# Logging
LOG_TO_CONSOLE=true
LOG_TO_FILE=false
EOF
    
    log "✅ Variáveis de ambiente configuradas para demo"
}

# Criar estrutura de diretórios se necessário
create_directory_structure() {
    log "📁 Verificando estrutura de diretórios..."
    
    local dirs=(
        "logs"
        "temp"
        "data/demo"
        "outputs"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log "Criado diretório: $dir"
        fi
    done
    
    log "✅ Estrutura de diretórios verificada"
}

# Executar testes básicos
run_basic_tests() {
    log "🧪 Executando testes básicos..."
    
    # Teste de importação dos módulos principais
    python3 -c "
import sys
import os
sys.path.append('src')

try:
    # Testar imports básicos
    import asyncio
    import json
    import time
    from datetime import datetime
    print('✅ Imports básicos: OK')
    
    # Testar estrutura de agentes
    if os.path.exists('src/agents'):
        print('✅ Estrutura de agentes: OK')
    else:
        print('⚠️ Estrutura de agentes: Não encontrada')
    
    # Testar script de demo
    if os.path.exists('src/tests/demo_scenario.py'):
        print('✅ Script de demonstração: OK')
    else:
        print('⚠️ Script de demonstração: Não encontrado')
        
    print('✅ Testes básicos concluídos')
    
except Exception as e:
    print(f'❌ Erro nos testes: {e}')
    sys.exit(1)
"
    
    log "✅ Testes básicos concluídos"
}

# Gerar dados de demonstração
generate_demo_data() {
    log "📊 Gerando dados de demonstração..."
    
    # Criar dados simulados para a demo
    mkdir -p data/demo
    
    # Arquivo de configuração de agentes
    cat > data/demo/agents_config.json << EOF
{
  "agents": {
    "coordinator": {
      "name": "Coordinator Agent",
      "role": "Orquestração e coordenação de tarefas",
      "capabilities": ["task_planning", "agent_coordination", "result_synthesis"],
      "response_time_avg": 1.5,
      "success_rate": 98.5
    },
    "analysis": {
      "name": "Analysis Agent", 
      "role": "Análise de dados e extração de insights",
      "capabilities": ["data_analysis", "pattern_recognition", "insight_extraction"],
      "response_time_avg": 2.8,
      "success_rate": 96.2
    },
    "generation": {
      "name": "Generation Agent",
      "role": "Geração de conteúdo e visualizações", 
      "capabilities": ["content_generation", "visualization", "report_creation"],
      "response_time_avg": 3.2,
      "success_rate": 94.8
    },
    "validation": {
      "name": "Validation Agent",
      "role": "Validação e verificação de qualidade",
      "capabilities": ["quality_check", "compliance_validation", "accuracy_verification"],
      "response_time_avg": 2.1,
      "success_rate": 99.1
    }
  }
}
EOF
    
    log "✅ Dados de demonstração gerados"
}

# Exibir instruções finais
show_final_instructions() {
    echo -e "\n${GREEN}🎉 SETUP CONCLUÍDO COM SUCESSO!${NC}\n"
    
    echo -e "${CYAN}📋 PRÓXIMOS PASSOS PARA DEMONSTRAÇÃO:${NC}\n"
    
    echo -e "${YELLOW}1. Executar demonstração interativa:${NC}"
    echo "   python3 src/tests/demo_scenario.py --interactive"
    echo ""
    
    echo -e "${YELLOW}2. Executar cenário específico:${NC}"
    echo "   python3 src/tests/demo_scenario.py --scenario 1  # Análise de documentos"
    echo "   python3 src/tests/demo_scenario.py --scenario 2  # Assistente empresarial"
    echo "   python3 src/tests/demo_scenario.py --scenario 3  # Automação de processos"
    echo ""
    
    echo -e "${YELLOW}3. Executar agentes individuais:${NC}"
    echo "   cd src/agents/coordinator && python3 main.py"
    echo ""
    
    echo -e "${BLUE}🔗 RECURSOS ÚTEIS:${NC}"
    echo "   • README.md - Documentação completa"
    echo "   • docs/workflows/ - Workflows do GitHub Actions"
    echo "   • monitoring/queries/ - Consultas KQL"
    echo "   • .env - Configurações de ambiente"
    echo ""
    
    echo -e "${PURPLE}🎯 DICAS PARA APRESENTAÇÃO:${NC}"
    echo "   • Use --interactive para pausas entre cenários"
    echo "   • Monitore logs em tempo real para mostrar atividade"
    echo "   • Demonstre métricas e observabilidade"
    echo "   • Explique arquitetura durante execução"
    echo ""
    
    echo -e "${GREEN}✅ Ambiente pronto para demonstração técnica!${NC}"
}

# Função principal
main() {
    local demo_mode=false
    
    # Processar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --demo-mode)
                demo_mode=true
                shift
                ;;
            --help|-h)
                echo "Uso: $0 [--demo-mode] [--help]"
                echo ""
                echo "Opções:"
                echo "  --demo-mode    Configuração otimizada para demonstração"
                echo "  --help, -h     Exibir esta ajuda"
                exit 0
                ;;
            *)
                log_error "Opção desconhecida: $1"
                exit 1
                ;;
        esac
    done
    
    print_banner
    
    log "🚀 Iniciando setup local para demonstração..."
    
    if [[ "$demo_mode" == true ]]; then
        log_info "Modo demonstração ativado - configuração otimizada"
    fi
    
    # Executar etapas do setup
    check_directory
    check_dependencies
    setup_python_environment
    setup_demo_environment
    create_directory_structure
    generate_demo_data
    run_basic_tests
    
    show_final_instructions
    
    log "🎉 Setup local concluído com sucesso!"
}

# Executar função principal
main "$@"

