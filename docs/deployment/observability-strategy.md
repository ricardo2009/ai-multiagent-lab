# Estratégia de Observabilidade e Monitoramento

## Visão Geral

A observabilidade é um pilar fundamental deste laboratório, permitindo o monitoramento proativo, a detecção de problemas e a análise de performance. A estratégia de observabilidade é baseada nos seguintes serviços do Azure:

*   **Azure Monitor**: Coleta e análise de métricas e logs de todos os recursos do Azure.
*   **Application Insights**: Monitoramento de performance de aplicações (APM) para os agentes e funções.
*   **Log Analytics**: Armazenamento e consulta de logs usando a linguagem de consulta Kusto (KQL).

## Logs Estruturados

Todas as aplicações e agentes devem gerar logs estruturados no formato JSON. Isso facilita a consulta e a análise dos logs no Log Analytics.

### Exemplo de Log Estruturado:

```json
{
  "timestamp": "2023-10-27T10:00:00Z",
  "level": "INFO",
  "message": "Task received",
  "agent_id": "coordinator-agent-123",
  "task_id": "task-456",
  "duration_ms": 120
}
```

## Métricas de Desempenho

As seguintes métricas de desempenho devem ser coletadas e monitoradas:

*   **Latência de API**: Tempo de resposta das APIs dos agentes.
*   **Taxa de Erros**: Porcentagem de requisições que resultam em erro.
*   **Uso de CPU e Memória**: Consumo de recursos dos containers no AKS.
*   **Taxa de Transferência de Mensagens**: Número de mensagens processadas por segundo no Service Bus.

## Dashboards de Monitoramento

Dashboards personalizados devem ser criados no Azure Monitor para visualizar as principais métricas e logs em tempo real. Os dashboards devem ser divididos por serviço e por funcionalidade.

## Alertas e Notificações

Alertas devem ser configurados para notificar a equipe de operações sobre problemas críticos, como:

*   **Alta Latência**: Quando a latência de uma API excede um determinado limite.
*   **Aumento na Taxa de Erros**: Quando a taxa de erros de um serviço aumenta significativamente.
*   **Recursos com Pouca Capacidade**: Quando o uso de CPU ou memória de um container está próximo do limite.

## Resolução de Problemas (Troubleshooting)

Uma seção dedicada a troubleshooting deve ser criada na documentação, com guias para diagnosticar e resolver problemas comuns. As consultas KQL para análise de logs devem ser documentadas e compartilhadas.


