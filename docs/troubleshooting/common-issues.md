# Guia de Resolução de Problemas Comuns

## Problema: Falha no Provisionamento da Infraestrutura

**Sintoma**: O workflow `Provision Azure Infrastructure` falha com um erro de `InvalidTemplate`.

**Causa Provável**: Erro de sintaxe nos arquivos Bicep ou Terraform.

**Solução**:

1.  Verifique os logs do workflow no GitHub Actions para identificar o erro específico.
2.  Valide os arquivos Bicep localmente usando o comando `az bicep build`.
3.  Valide os arquivos Terraform localmente usando o comando `terraform validate`.

## Problema: Erro de Autenticação do Agente

**Sintoma**: O agente não consegue se autenticar no Azure e acessar os recursos necessários.

**Causa Provável**: Configuração incorreta do Entra ID ou do Key Vault.

**Solução**:

1.  Verifique se o registro de aplicação do agente no Entra ID está configurado corretamente.
2.  Verifique se as permissões de API foram concedidas corretamente.
3.  Verifique se o agente está usando a identidade gerenciada correta para acessar o Key Vault.

## Problema: Alta Latência nas Respostas da API

**Sintoma**: As requisições para as APIs dos agentes estão demorando muito para responder.

**Causa Provável**: Sobrecarga de recursos ou código ineficiente.

**Solução**:

1.  Use o Application Insights para identificar gargalos de performance no código.
2.  Monitore o uso de CPU e memória dos containers no AKS e aumente os recursos se necessário.
3.  Otimize as consultas ao Cosmos DB e use o cache do Redis para dados frequentemente acessados.

## Consultas KQL Úteis

Consulte o arquivo `monitoring/queries/common-queries.kql` para uma lista de consultas Kusto (KQL) úteis para troubleshooting.


