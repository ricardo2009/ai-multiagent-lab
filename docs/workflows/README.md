# GitHub Actions Workflows

Este diretório contém os workflows do GitHub Actions para o laboratório de IA Multiagente. Devido às limitações de escopo do token, os workflows estão documentados aqui e devem ser copiados manualmente para `.github/workflows/` quando configurar o repositório com as permissões adequadas.

## 📋 Workflows Disponíveis

### 1. **ci-cd-matrix.yml** - Pipeline Principal de CI/CD
**Estratégia de Matriz Multi-dimensional**

```yaml
strategy:
  matrix:
    python-version: [3.9, 3.10, 3.11]
    test-type: [unit, integration, security]
    platform: [linux/amd64, linux/arm64]
```

**Características:**
- ✅ **9 Jobs Principais** com matriz de execução paralela
- ✅ **Build & Test Matrix**: Testes em múltiplas versões Python e tipos
- ✅ **Infrastructure Validation**: Validação Bicep/Terraform por ambiente
- ✅ **Security Scanning**: Varredura de segredos, dependências, código e infraestrutura
- ✅ **Container Build**: Build multi-arquitetura para todos os agentes
- ✅ **Deploy Matrix**: Deploy por ambiente (dev/staging/prod)
- ✅ **Integration Tests**: Testes de integração pós-deploy
- ✅ **Production Deploy**: Deploy em produção com aprovação manual
- ✅ **Notification**: Relatórios e notificações automáticas

**Triggers:**
- Push para `main` e `develop`
- Pull requests para `main`
- Execução manual com parâmetros personalizáveis

---

### 2. **infrastructure-provisioning.yml** - Provisionamento de Infraestrutura
**Estratégia de Matriz para Infraestrutura**

```yaml
strategy:
  matrix:
    component: [main, networking, security, monitoring]
    workspace: [development, staging, production]
    tool: [bicep, terraform]
```

**Características:**
- ✅ **6 Jobs Especializados** para provisionamento completo
- ✅ **Pre-deployment Validation**: Validação de permissões e configurações
- ✅ **Bicep Deployment Matrix**: Deploy modular com Bicep
- ✅ **Terraform Deployment Matrix**: Deploy com workspaces Terraform
- ✅ **Post-deployment Validation**: Testes de conectividade, segurança e performance
- ✅ **Resource Documentation**: Geração automática de inventário e diagramas
- ✅ **Notification & Cleanup**: Relatórios e limpeza automática

**Parâmetros de Entrada:**
- `environment`: development/staging/production
- `infrastructure_tool`: bicep/terraform/both
- `destroy_existing`: true/false
- `dry_run`: true/false

---

### 3. **agent-deployment.yml** - Deploy de Agentes
**Estratégias de Deploy Avançadas**

```yaml
strategy:
  matrix:
    agent: [coordinator, analysis-agent, generation-agent, validation-agent]
    deployment_strategy: [rolling, blue-green, canary]
```

**Características:**
- ✅ **8 Jobs Especializados** para deploy de agentes
- ✅ **Setup Matrix**: Configuração dinâmica de agentes para deploy
- ✅ **Build Images**: Build e scan de segurança de imagens Docker
- ✅ **K8s Manifests**: Geração automática de manifestos Kubernetes
- ✅ **Rolling Deploy**: Deploy incremental para desenvolvimento
- ✅ **Blue-Green Deploy**: Deploy zero-downtime para staging
- ✅ **Canary Deploy**: Deploy gradual para produção (10% → 50% → 100%)
- ✅ **Post-deployment Testing**: Testes de saúde, integração e carga
- ✅ **Rollback**: Rollback automático em caso de falha

**Estratégias de Deploy:**
- **Rolling**: Atualização gradual dos pods
- **Blue-Green**: Troca instantânea entre versões
- **Canary**: Deploy gradual com monitoramento

---

### 4. **testing-matrix.yml** - Matriz de Testes Abrangente
**Testes Multi-dimensionais**

```yaml
strategy:
  matrix:
    python-version: [3.9, 3.10, 3.11, 3.12]
    test-suite: [unit, integration, e2e, performance, security]
    environment: [development, staging, production]
```

**Características:**
- ✅ **8 Jobs de Teste** com cobertura completa
- ✅ **Unit Tests Matrix**: Testes unitários por componente e categoria
- ✅ **Integration Tests**: Testes de integração com serviços externos
- ✅ **E2E Tests**: Testes end-to-end com Playwright em múltiplos browsers
- ✅ **Performance Tests**: Testes de carga com Locust (load/stress/spike/volume)
- ✅ **Security Tests**: Varredura com Bandit, Safety, Semgrep, Trivy
- ✅ **Test Aggregation**: Agregação e análise de resultados
- ✅ **Quality Gates**: Portões de qualidade com thresholds configuráveis

**Tipos de Teste:**
- **Unit**: Testes unitários com cobertura
- **Integration**: Testes de integração com Redis/PostgreSQL
- **E2E**: Testes end-to-end com browsers
- **Performance**: Testes de carga e stress
- **Security**: Varredura de segurança multi-ferramenta

---

### 5. **monitoring-alerts.yml** - Monitoramento e Alertas
**Monitoramento em Tempo Real**

```yaml
strategy:
  matrix:
    environment: [development, staging, production]
    metric_type: [availability, performance, cost, security]
    time_window: [15m, 1h, 6h, 24h]
```

**Características:**
- ✅ **5 Jobs de Monitoramento** especializados
- ✅ **Infrastructure Monitoring**: Monitoramento de AKS, Cosmos DB, Functions
- ✅ **Application Monitoring**: Monitoramento de saúde e performance dos agentes
- ✅ **Security Monitoring**: Monitoramento de segurança em tempo real
- ✅ **Performance Monitoring**: Análise de métricas de performance
- ✅ **Alert Aggregation**: Agregação e notificação de alertas

**Execução:**
- **Agendado**: A cada 15 minutos (alertas) e 6 horas (relatórios)
- **Manual**: Com escopo e nível de alerta configuráveis
- **Automático**: Integração com consultas KQL existentes

---

## 🚀 Como Usar os Workflows

### 1. **Configuração Inicial**
```bash
# Copiar workflows para o diretório correto
cp docs/workflows/*.yml .github/workflows/

# Configurar secrets no GitHub
# - AZURE_CREDENTIALS
# - AZURE_SUBSCRIPTION_ID
# - REGISTRY_USERNAME
# - REGISTRY_PASSWORD
```

### 2. **Execução Manual**
Todos os workflows suportam execução manual via `workflow_dispatch` com parâmetros personalizáveis:

- **Environment**: development/staging/production
- **Scope**: Escopo específico do workflow
- **Options**: Opções específicas como dry-run, rollback, etc.

### 3. **Execução Automática**
- **Push/PR**: Triggers automáticos para CI/CD
- **Schedule**: Execução agendada para monitoramento
- **Dependencies**: Workflows dependentes executam em sequência

---

## 📊 Matriz de Execução

| Workflow | Jobs | Matrix Combinations | Execution Time | Parallel Jobs |
|----------|------|-------------------|----------------|---------------|
| CI/CD Matrix | 9 | 54+ combinations | 45-60 min | 20+ |
| Infrastructure | 6 | 18+ combinations | 30-45 min | 12+ |
| Agent Deploy | 8 | 32+ combinations | 25-40 min | 16+ |
| Testing Matrix | 8 | 100+ combinations | 60-90 min | 30+ |
| Monitoring | 5 | 72+ combinations | 15-30 min | 24+ |

**Total**: **36 Jobs** com **300+ combinações de matriz** executando em paralelo

---

## 🔧 Configurações Necessárias

### **Secrets do GitHub**
```yaml
AZURE_CREDENTIALS: # Service Principal JSON
AZURE_SUBSCRIPTION_ID: # Azure Subscription ID
REGISTRY_USERNAME: # ACR Username
REGISTRY_PASSWORD: # ACR Password
```

### **Environments**
- `development`: Deploy automático
- `staging`: Deploy automático com aprovação
- `production`: Deploy manual com aprovação obrigatória

### **Permissions**
- `contents: read`
- `actions: read`
- `security-events: write`
- `packages: write`

---

## 📈 Benefícios dos Workflows

### **Automação Completa**
- ✅ Provisionamento automático de infraestrutura
- ✅ Build e deploy automático de aplicações
- ✅ Testes automatizados em múltiplas dimensões
- ✅ Monitoramento e alertas em tempo real

### **Qualidade e Segurança**
- ✅ Testes de segurança em cada etapa
- ✅ Validação de qualidade com portões
- ✅ Rollback automático em falhas
- ✅ Compliance e auditoria automática

### **Escalabilidade e Performance**
- ✅ Execução paralela massiva
- ✅ Cache inteligente de dependências
- ✅ Otimização de recursos
- ✅ Monitoramento de performance

### **Observabilidade**
- ✅ Logs estruturados e métricas
- ✅ Dashboards automáticos
- ✅ Alertas inteligentes
- ✅ Relatórios executivos

---

## 🎯 Próximos Passos

1. **Configurar Secrets**: Adicionar credenciais Azure no GitHub
2. **Copiar Workflows**: Mover arquivos para `.github/workflows/`
3. **Testar Execução**: Executar workflows manualmente
4. **Configurar Ambientes**: Configurar environments com aprovações
5. **Monitorar Execução**: Acompanhar execução e otimizar

---

*Estes workflows representam as melhores práticas de DevOps para projetos de IA e multiagentes, proporcionando automação completa, qualidade garantida e observabilidade total.*

