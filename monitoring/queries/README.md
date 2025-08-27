# Consultas KQL para Monitoramento e Troubleshooting

Este diretório contém uma coleção abrangente de consultas Kusto Query Language (KQL) para monitoramento, troubleshooting e análise do laboratório de IA multiagentes.

## Estrutura dos Arquivos

### 1. `agent-monitoring.kql`
**Propósito**: Monitoramento geral da saúde e performance dos agentes

**Consultas Incluídas**:
- Visão geral da saúde dos agentes
- Latência média por agente
- Detecção de anomalias de performance
- Análise de erros por tipo
- Throughput de mensagens entre agentes
- Análise de dependências externas

**Uso Recomendado**: Dashboards de monitoramento em tempo real e alertas proativos.

### 2. `troubleshooting.kql`
**Propósito**: Diagnóstico e resolução de problemas específicos

**Consultas Incluídas**:
- Rastreamento de transação completa
- Análise de falhas em cascata
- Detecção de deadlocks e timeouts
- Análise de consumo de recursos
- Padrões de erro recorrentes
- Comunicação interrompida
- Detecção de loops infinitos
- Degradação gradual de performance

**Uso Recomendado**: Investigação de incidentes e análise post-mortem.

### 3. `performance-analysis.kql`
**Propósito**: Análise detalhada de performance e otimização

**Consultas Incluídas**:
- Performance por horário
- Comparação entre versões
- Análise de gargalos
- Análise de concorrência
- Eficiência de cache
- Throughput por agente
- Utilização de recursos por carga
- Padrões de falha relacionados à performance

**Uso Recomendado**: Otimização de performance e planejamento de capacidade.

### 4. `business-metrics.kql`
**Propósito**: Métricas de negócio e valor entregue

**Consultas Incluídas**:
- Tarefas completadas por agente
- Qualidade de resultados
- Tempo de resposta ao usuário
- Utilização de recursos de IA
- Satisfação do usuário
- Eficiência operacional
- Padrões de uso
- Análise de ROI

**Uso Recomendado**: Relatórios executivos e análise de valor de negócio.

### 5. `security-monitoring.kql`
**Propósito**: Monitoramento de segurança e detecção de ameaças

**Consultas Incluídas**:
- Tentativas de acesso não autorizado
- Anomalias de comportamento
- Acesso a dados sensíveis
- Detecção de injeção de código
- Auditoria de alterações de configuração
- Comunicação criptografada
- Tokens e certificados expirados
- Atividade suspeita fora do horário
- Privilégios elevados
- Correlação de eventos de segurança

**Uso Recomendado**: SOC (Security Operations Center) e compliance.

## Como Usar as Consultas

### 1. No Azure Monitor
```kusto
// Copie e cole a consulta desejada no Azure Monitor
// Ajuste os parâmetros conforme necessário (datas, thresholds, etc.)
```

### 2. Em Dashboards
- Use as consultas como base para criar visualizações
- Configure alertas baseados nos resultados
- Crie workbooks interativos

### 3. Em Alertas Automáticos
```kusto
// Exemplo de alerta para alta latência
AppRequests
| where TimeGenerated > ago(5m)
| where Name contains "agent"
| summarize AvgLatency = avg(DurationMs) by bin(TimeGenerated, 1m)
| where AvgLatency > 5000 // Alerta se latência > 5 segundos
```

## Personalização das Consultas

### Parâmetros Comuns para Ajustar:

1. **Janela de Tempo**: Modifique `ago(1h)`, `ago(24h)`, etc.
2. **Thresholds**: Ajuste valores como latência máxima, taxa de erro, etc.
3. **Filtros de Agente**: Modifique `agent_id` ou `AgentName` para focar em agentes específicos
4. **Intervalos de Agregação**: Ajuste `bin(TimeGenerated, 5m)` conforme necessário

### Exemplo de Personalização:
```kusto
// Consulta original
AppRequests | where TimeGenerated > ago(1h)

// Personalizada para últimas 4 horas
AppRequests | where TimeGenerated > ago(4h)

// Personalizada para agente específico
AppRequests 
| where TimeGenerated > ago(1h)
| where Name contains "coordinator-agent"
```

## Boas Práticas

### 1. Performance das Consultas
- Use filtros de tempo específicos para evitar consultas muito amplas
- Aplique filtros no início da consulta para reduzir o volume de dados
- Use `summarize` para agregar dados quando possível

### 2. Alertas Inteligentes
- Configure thresholds baseados em dados históricos
- Use janelas de tempo apropriadas para evitar falsos positivos
- Implemente supressão de alertas para evitar spam

### 3. Monitoramento Contínuo
- Execute consultas críticas regularmente
- Mantenha dashboards atualizados
- Revise e ajuste consultas conforme o sistema evolui

## Integração com Ferramentas

### Azure Monitor Workbooks
```json
{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "// Cole sua consulta KQL aqui",
        "size": 0,
        "timeContext": {
          "durationMs": 3600000
        }
      }
    }
  ]
}
```

### Power BI
- Use o conector do Azure Monitor para importar dados
- Crie relatórios executivos baseados nas métricas de negócio
- Configure atualizações automáticas

### Grafana
- Configure datasource do Azure Monitor
- Crie dashboards personalizados
- Use alerting do Grafana para notificações

## Troubleshooting das Consultas

### Erros Comuns:

1. **"Column not found"**: Verifique se as propriedades personalizadas estão sendo enviadas corretamente
2. **"No data"**: Confirme se os agentes estão enviando telemetria
3. **"Query timeout"**: Reduza a janela de tempo ou adicione mais filtros

### Validação de Dados:
```kusto
// Verificar se dados estão chegando
AppTraces
| where TimeGenerated > ago(10m)
| take 10

// Verificar propriedades disponíveis
AppTraces
| where TimeGenerated > ago(1h)
| extend props = todynamic(Properties)
| evaluate bag_unpack(props)
| take 5
```

## Contribuindo

Para adicionar novas consultas:

1. Siga o padrão de nomenclatura existente
2. Inclua comentários explicativos
3. Teste a consulta com dados reais
4. Documente o propósito e uso recomendado
5. Adicione exemplos de personalização

## Suporte

Para dúvidas sobre as consultas KQL:
- Consulte a [documentação oficial do KQL](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- Use o [KQL playground](https://dataexplorer.azure.com/clusters/help/databases/Samples) para testar consultas
- Verifique os logs de exemplo no Application Insights

