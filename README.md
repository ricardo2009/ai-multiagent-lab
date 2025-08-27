# Laboratório de IA Generativa e Multiagentes com Tecnologias Microsoft

Este projeto é um laboratório técnico completo e altamente automatizado para demonstração prática de aplicações inteligentes utilizando IA generativa e orquestração de multiagentes com tecnologias Microsoft.

## Arquitetura

A arquitetura completa do laboratório, incluindo um diagrama detalhado, pode ser encontrada na pasta `docs/architecture`.

## Funcionalidades

*   **Automação com GitHub Actions**: Pipelines para provisionamento, deploy e testes.
*   **Infraestrutura como Código**: Scripts Bicep e Terraform para provisionamento de recursos no Azure.
*   **Agentes Autônomos**: Código-fonte para agentes autônomos utilizando Azure AI Foundry.
*   **Integração com Copilot Studio**: Personalização de experiências conversacionais.
*   **Arquitetura Moderna**: Uso de Azure Functions, Cosmos DB e AKS.
*   **Segurança e Identidade**: Configuração de identidade de agentes com Entra ID e boas práticas de segurança.
*   **Observabilidade**: Monitoramento com Azure Monitor e Application Insights.

## Começando

### Pré-requisitos

*   [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (opcional)
*   [Docker](https://docs.docker.com/get-docker/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   [Helm](https://helm.sh/docs/intro/install/)
*   [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

### Execução Local

1.  Clone o repositório:
    ```bash
    git clone https://github.com/your-username/ai-multiagent-lab.git
    cd ai-multiagent-lab
    ```

2.  Faça login no Azure:
    ```bash
    az login
    ```

3.  Provisione a infraestrutura usando Bicep:
    ```bash
    az deployment sub create --location eastus --template-file ./infrastructure/bicep/main.bicep
    ```

4.  Execute os agentes localmente (exemplo):
    ```bash
    cd src/agents/coordinator
    pip install -r requirements.txt
    python main.py
    ```

### Execução na Azure

1.  Configure os segredos do GitHub Actions (`AZURE_CREDENTIALS`, `AZURE_SUBSCRIPTION_ID`).
2.  Execute o workflow `Provision Azure Infrastructure`.
3.  Execute o workflow `Deploy Agents to AKS`.

## Uso

Consulte a pasta `docs/examples` para exemplos de uso do laboratório.

## Automação

Os workflows do GitHub Actions estão localizados na pasta `.github/workflows`.

*   `provision-infra.yml`: Provisiona a infraestrutura no Azure.
*   `deploy-agents.yml`: Faz o deploy dos agentes no AKS.
*   `run-tests.yml`: Executa os testes automatizados.

## Segurança

Consulte o documento `docs/deployment/security-best-practices.md` para mais informações sobre as boas práticas de segurança implementadas no laboratório.

## Observabilidade

Consulte o documento `docs/deployment/observability-strategy.md` para mais informações sobre a estratégia de observabilidade e monitoramento.

## Troubleshooting

Consulte a pasta `docs/troubleshooting` para guias de resolução de problemas comuns.

## Contribuindo

Contribuições são bem-vindas! Por favor, abra uma issue ou um pull request para discutir suas ideias.

## Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.


