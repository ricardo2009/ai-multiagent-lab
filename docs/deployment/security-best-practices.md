# Boas Práticas de Segurança e Controle de Acesso

## Identidade dos Agentes com Entra ID

Cada agente no laboratório deve ter sua própria identidade gerenciada no Microsoft Entra ID. Isso permite um controle de acesso granular e auditoria completa das ações de cada agente.

### Passos para Configuração:

1.  **Registro de Aplicação**: Crie um registro de aplicação no Entra ID para cada agente.
2.  **Permissões de API**: Conceda as permissões de API necessárias para cada agente, seguindo o princípio do menor privilégio.
3.  **Autenticação**: Configure a autenticação usando o fluxo de credenciais do cliente (client credentials flow) para comunicação de serviço a serviço.
4.  **Segredos e Certificados**: Use certificados para autenticação em vez de segredos de cliente sempre que possível.

## Controle de Acesso Baseado em Função (RBAC)

O Azure RBAC é usado para controlar o acesso aos recursos do Azure. As identidades dos agentes devem receber apenas as funções necessárias para executar suas tarefas.

### Exemplos de Atribuição de Função:

*   **Agente de Análise**: Pode ter a função de `Leitor de Dados de Blob de Armazenamento` para acessar dados de treinamento.
*   **Agente de Deploy**: Pode ter a função de `Colaborador` no grupo de recursos do AKS para gerenciar deployments.

## Azure Key Vault para Gerenciamento de Segredos

Todos os segredos, chaves e certificados devem ser armazenados no Azure Key Vault. As aplicações e agentes devem ser configurados para acessar o Key Vault usando identidades gerenciadas.

### Vantagens:

*   **Centralização**: Gerenciamento centralizado de todos os segredos.
*   **Segurança**: Hardware Security Modules (HSMs) para proteção de chaves.
*   **Auditoria**: Logs detalhados de acesso a segredos.

## Segurança de Rede

*   **Rede Virtual (VNet)**: Todos os recursos devem ser implantados em uma VNet para isolamento de rede.
*   **Grupos de Segurança de Rede (NSGs)**: Use NSGs para restringir o tráfego de entrada e saída para as sub-redes.
*   **Endpoints Privados**: Use endpoints privados para acessar os serviços do Azure de forma segura a partir da VNet.

## Monitoramento de Segurança

*   **Microsoft Defender for Cloud**: Habilite o Defender for Cloud para monitoramento contínuo de segurança e detecção de ameaças.
*   **Microsoft Sentinel**: Integre os logs do Azure com o Microsoft Sentinel para análise de segurança e resposta a incidentes.


