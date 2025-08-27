# Exemplo de Uso

## Cenário: Análise de Sentimento de Notícias

Neste exemplo, vamos usar o laboratório para analisar o sentimento de um conjunto de notícias sobre uma determinada empresa.

### Passo 1: Enviar a Tarefa para o Agente Coordenador

Podemos enviar a tarefa para o agente coordenador através de uma requisição HTTP para a sua API:

```bash
curl -X POST http://localhost:8000/tasks/ -H "Content-Type: application/json" -d '{
  "description": "Analisar o sentimento das últimas notícias sobre a empresa X"
}'
```

### Passo 2: Orquestração dos Agentes

O agente coordenador recebe a tarefa e a divide em subtarefas para os agentes especializados:

1.  **Agente de Integração**: Busca as últimas notícias sobre a empresa X em diversas fontes (APIs de notícias, web scraping, etc.).
2.  **Agente de Análise**: Para cada notícia, utiliza um modelo de análise de sentimento para classificar o sentimento como positivo, negativo ou neutro.
3.  **Agente de Geração**: Gera um relatório resumido com os resultados da análise, incluindo gráficos e principais insights.
4.  **Agente de Validação**: Valida a qualidade e a precisão do relatório gerado.

### Passo 3: Receber o Resultado

O agente coordenador consolida os resultados e os retorna para o usuário. O resultado pode ser um link para o relatório gerado ou o próprio relatório em formato JSON.

## Testes Automatizados

Os testes automatizados para este cenário podem ser encontrados na pasta `src/tests`. Para executá-los, use o seguinte comando:

```bash
pytest src/tests/test_sentiment_analysis.py
```


