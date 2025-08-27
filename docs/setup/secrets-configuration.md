# Configuração de Secrets e Variáveis

Este documento fornece instruções detalhadas para configurar os secrets e variáveis necessários para os workflows do GitHub Actions.

## 🔐 Secrets Necessários

### 1. **AZURE_CREDENTIALS**
**Descrição**: Credenciais do Service Principal do Azure para autenticação

**Formato JSON**:
```json
{
  "clientId": "12345678-1234-1234-1234-123456789012",
  "clientSecret": "your-client-secret-here",
  "subscriptionId": "87654321-4321-4321-4321-210987654321",
  "tenantId": "11111111-2222-3333-4444-555555555555"
}
```

**Como obter**:
1. Acesse o Azure Portal
2. Vá para **Azure Active Directory** > **App registrations**
3. Clique em **New registration**
4. Preencha o nome (ex: "ai-multiagent-lab-sp")
5. Clique em **Register**
6. Copie o **Application (client) ID** e **Directory (tenant) ID**
7. Vá para **Certificates & secrets** > **New client secret**
8. Copie o **Value** do secret criado
9. Vá para **Subscriptions** > Sua subscription > **Access control (IAM)**
10. Clique em **Add role assignment**
11. Selecione **Contributor** e adicione o Service Principal criado

### 2. **AZURE_SUBSCRIPTION_ID**
**Descrição**: ID da subscription do Azure

**Exemplo**: `87654321-4321-4321-4321-210987654321`

**Como obter**:
1. Acesse o Azure Portal
2. Vá para **Subscriptions**
3. Copie o **Subscription ID**

### 3. **REGISTRY_USERNAME**
**Descrição**: Username do Azure Container Registry

**Exemplo**: `acraimultiagentlab`

**Como obter**:
1. Acesse o Azure Portal
2. Vá para **Container registries**
3. Selecione seu registry (ou crie um novo)
4. Vá para **Access keys**
5. Copie o **Username**

### 4. **REGISTRY_PASSWORD**
**Descrição**: Password do Azure Container Registry

**Exemplo**: `your-acr-password-here`

**Como obter**:
1. No mesmo local do username
2. Copie uma das **Password** disponíveis

## 🛠️ Como Configurar no GitHub

### **Método 1: Via Interface Web**
1. Vá para o repositório no GitHub
2. Clique em **Settings** > **Secrets and variables** > **Actions**
3. Clique em **New repository secret**
4. Adicione cada secret com o nome exato e valor correspondente

### **Método 2: Via GitHub CLI**
```bash
# AZURE_CREDENTIALS (substitua pelo JSON real)
gh secret set AZURE_CREDENTIALS --body '{
  "clientId": "seu-client-id",
  "clientSecret": "seu-client-secret", 
  "subscriptionId": "seu-subscription-id",
  "tenantId": "seu-tenant-id"
}'

# AZURE_SUBSCRIPTION_ID
gh secret set AZURE_SUBSCRIPTION_ID --body "seu-subscription-id"

# REGISTRY_USERNAME  
gh secret set REGISTRY_USERNAME --body "seu-registry-username"

# REGISTRY_PASSWORD
gh secret set REGISTRY_PASSWORD --body "sua-registry-password"
```

## 🌍 Environments Configurados

### **Development**
- ✅ Deploy automático
- ✅ Sem aprovação necessária
- ✅ Qualquer branch pode fazer deploy

### **Staging** 
- ✅ Deploy automático
- ✅ Wait timer de 5 minutos
- ✅ Qualquer branch pode fazer deploy

### **Production**
- ✅ Deploy manual
- ✅ Aprovação obrigatória do usuário `ricardo2009`
- ✅ Apenas branches protegidas podem fazer deploy

## 📋 Checklist de Configuração

### **Pré-requisitos Azure**
- [ ] Subscription do Azure ativa
- [ ] Service Principal criado com permissões de Contributor
- [ ] Azure Container Registry criado
- [ ] Resource Groups criados (opcional, serão criados automaticamente)

### **Configuração GitHub**
- [ ] Repository secrets configurados
- [ ] Environments criados (development, staging, production)
- [ ] Branch protection rules configuradas (para production)
- [ ] Workflows ativos e funcionando

### **Teste de Configuração**
- [ ] Executar workflow de teste manualmente
- [ ] Verificar logs de execução
- [ ] Confirmar autenticação Azure
- [ ] Validar acesso ao Container Registry

## 🔍 Verificação de Secrets

Para verificar se os secrets estão configurados corretamente:

```bash
# Listar secrets configurados (não mostra valores)
gh secret list

# Verificar environments
gh api repos/OWNER/REPO/environments
```

## 🚨 Troubleshooting

### **Erro de Autenticação Azure**
- Verifique se o Service Principal tem permissões adequadas
- Confirme se o JSON do AZURE_CREDENTIALS está bem formatado
- Verifique se o clientSecret não expirou

### **Erro de Container Registry**
- Confirme se o registry existe e está acessível
- Verifique se as credenciais estão corretas
- Confirme se o Service Principal tem acesso ao registry

### **Erro de Environment**
- Verifique se os environments foram criados
- Confirme as regras de proteção
- Verifique se o usuário tem permissões adequadas

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs dos workflows no GitHub Actions
2. Confirme se todos os secrets estão configurados
3. Teste a autenticação Azure localmente
4. Verifique as permissões do Service Principal

---

*Esta configuração garante que todos os workflows funcionem corretamente com segurança e controle de acesso adequados.*

