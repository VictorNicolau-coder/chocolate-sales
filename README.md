# Trabalho Prático SQL N1

## 📚 Sobre o Projeto

Este projeto foi desenvolvido como parte da disciplina de Banco de Dados, com foco na aplicação de conceitos avançados de SQL em um banco de dados relacional baseado em dados reais.

O objetivo principal é realizar extração, análise e organização de informações utilizando recursos avançados do SQL, como:

* Common Table Expressions (CTEs)
* Funções de Janela (Window Functions)
* Views
* Triggers
* Stored Procedures
* Auditoria e validações de regras de negócio

---

# 👥 Integrantes

* Victor Anderson Bizerra Nicolau

---

# 🗂️ Base de Dados Utilizada

## Dataset

O projeto utiliza uma base de dados de vendas de chocolates chamada `ChocolateSales`, contendo informações sobre:

* vendas;
* produtos;
* clientes;
* lojas;
* lucros e custos;
* dados temporais de pedidos.

A base foi utilizada para aplicar conceitos avançados de SQL voltados para análise de dados, monitoramento de desempenho comercial e garantia de regras de negócio.

## Fonte

```txt
https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024
```

---

# 🧱 Estrutura do Banco de Dados

O banco de dados possui pelo menos 5 tabelas relacionadas através de chaves primárias e estrangeiras.

## Principais tabelas

| Tabela   | Descrição |
| -------- | --------- |
| calendar | útil para análise baseada no tempo |
| customers | Dados dos clientes |
| products | Catálogo de produtos |
| sales | Registro das vendas realizadas |
| stores | Informações das lojas |

---

# ⚙️ Tecnologias Utilizadas

* SQL
* MySQL
* Python
* Kaggle Dataset

---

# 🚀 Como Executar o Projeto

## 1. Clonar o repositório

```bash
git clone <url-do-repositorio>
```

## 2. Criar o banco de dados e inserir os dadoss

Execute os scripts de criação das tabelas:

```python
SOURCE schema.sql;
```

## 4. Executar consultas e procedures

Os scripts SQL estão organizados por questão:

```txt
/q1
/q2
/q3
/q4
/q5
```

---

# 📊 Q1 — Panorama Temporal e Ranking

## Objetivo

Analisar a evolução temporal das vendas e identificar os produtos e lojas com maior lucro em cada semestre.

## Recursos utilizados

* `DENSE_RANK()`
* CTEs
* Agrupamentos temporais
* Particionamento por semestre

## O que foi desenvolvido

Foi criada uma view responsável por:

* agrupar as vendas por semestre;
* calcular o lucro total e quantidade total vendida;
* gerar rankings de desempenho utilizando DENSE_RANK();
* identificar os produtos e lojas mais lucrativos em cada período.

O semestre foi dividido em:

* .1 → primeiro semestre;
* .2 → segundo semestre.

Os empates foram tratados utilizando DENSE_RANK(), garantindo posições iguais para lucros equivalentes.

## Exemplo de utilização

```sql
SELECT * FROM vw_ranking WHERE ranking_position <= 3;
```
A consulta retorna os 3 melhores desempenhos de cada semestre.

---

# 📈 Q2 — View Analítica

## Objetivo

Monitorar o desempenho financeiro das lojas e identificar aquelas que estão acima da média global de lucro.

## View criada

```sql
vw_monitoramento_vendas
```

## Critérios de priorização

| Prioridade | Regra     |
| ---------- | --------- |
| 1          | Lucro acima de 120% da média global |
| 2          | Lucro acima de 110% da média global |
| 3          | Lucro igual ou próximo da média global |

## Recursos utilizados

* CTEs
* Agregações (`SUM`, `AVG`)
* CASE WHEN
* CROSS JOIN

## Objetivo da View

A view foi desenvolvida para:

* calcular o lucro mensal de cada loja;
* comparar os resultados com a média global;
* gerar um percentual comparativo;
* priorizar lojas com melhor desempenho financeiro.

O percentual é calculado utilizando a seguinte lógica:
```sql
(lucro_total / media_lucro) * 100
```
Essa análise auxilia no acompanhamento de desempenho das unidades comerciais.

---

# 🔒 Q3 — Garantia de Regra de Negócio

## Objetivo

Garantir que vendas inválidas não sejam inseridas ou atualizadas no banco de dados.

## Regra de negócio implementada

Não é permitido registrar vendas com quantidade menor ou igual a zero.

## Triggers criadas

```sql
trg_sales_before_insert
trg_sales_before_update
```

## Funcionamento

As triggers verificam:

```sql
IF NEW.quantity <= 0
```

Caso a regra seja violada:

* a operação é bloqueada;
* um erro é lançado utilizando SIGNAL SQLSTATE;
* uma auditoria é registrada na tabela sales_audit_log.

## Auditoria

Foi criada uma tabela de log para registrar:

* Timestamp;
* Usuário;
* Operação realizada;
* Problema identificado;
* SQL executado;

## Exemplo de tentativa inválida

```sql
INSERT INTO sales(...)
VALUES (..., 0, ...);
```

Resultado: 

```sql
Erro: quantidade de venda inválida (<= 0)
```

---

# 🧾 Q4 — Stored Procedure

## Objetivo

Automatizar relatórios de vendas filtrando informações por semestre e produto.

## Procedure criada

```sql
filtro_vendas
```

## Parâmetros

| Parâmetro   | Tipo | Descrição |
| ----------- | ---- | --------- |
| p_semestre | VARCHAR(6) | Filtra o semestre desejado |
| p_produto | VARCHAR(255) | Filtra o nome do produto |

## Recursos utilizados

* JOINs
* Agregações (`SUM`, `AVG`)
* CTEs
* Agrupamentos
* Filtros parametrizados

## Informações retornadas

A procedure retorna:

* nome do produto;
* semestre;
* total vendido;
* lucro total;
* média de vendas.

## Exemplo de execução

```sql
CALL filtro_vendas(NULL, 'White Chocolate 60%');
```

Esse comando retorna os dados de vendas do produto informado em todos os semestres.

---

# 👔 Q5 — Views para Diferentes Perfis

## Objetivo

Criar diferentes visões do banco de dados para públicos distintos.

---

## 📌 View Gerencial

### Nome

```sql
vw_painel_vendas_gerencial
```

### Objetivo

Apresentar indicadores estratégicos resumidos sobre o desempenho das lojas.

### Informações exibidas

* país;
* nome da loja;
* total de pedidos;
* quantidade total de itens vendidos;
* receita total;
* ticket médio.

Essa view foi projetada para auxiliar gestores na tomada de decisão.

---

## 📌 View Analítica

### Nome

```sql
vw_painel_vendas_detalhadas
```

### Objetivo

Exibir informações completas e detalhadas das vendas realizadas.

### Informações exibidas

* identificador da venda;
* data do pedido;
* cliente;
* produto;
* loja;
* país;
* quantidade vendida;
* custo;
* valor total da venda.

Essa view foi criada para análises operacionais e detalhadas do negócio.

---

# 📂 Organização do Repositório

```txt
📦 Trabalho-Pratico-SQL-N1
 ┣ 📜 README.md
 ┗ 📂 src
    ┣ 📂 csv
    ┃ ┣ 📜 calendar.csv
    ┃ ┣ 📜 customers.csv
    ┃ ┣ 📜 products.csv
    ┃ ┣ 📜 sales.csv
    ┃ ┗ 📜 stores.csv
    ┣ 📂 output
    ┃ ┗ 📄 Arquivos gerados pelas consultas e análises
    ┗ 📂 scripts
       ┣ 📜 converter.py
       ┣ 📜 Q1.sql
       ┣ 📜 Q2.sql
       ┣ 📜 Q3.sql
       ┣ 📜 Q4.sql
       ┗ 📜 Q5.sql
```

---

# ✅ Requisitos Atendidos

* [x] Uso de CTEs
* [x] Uso de funções de janela
* [x] Uso de Views
* [x] Uso de Trigger
* [x] Uso de Procedure
* [x] Auditoria de operações
* [x] Relatórios parametrizados
* [x] Banco com múltiplas tabelas relacionais

---

# 📌 Considerações Finais

Este projeto permitiu aplicar conceitos avançados de SQL em um cenário próximo ao mundo real, envolvendo análise de dados, automação de relatórios, controle de regras de negócio e criação de visões específicas para diferentes tipos de usuários.

Além disso, o trabalho contribuiu para o desenvolvimento de habilidades relacionadas à modelagem relacional, organização de consultas complexas e otimização de análises em bancos de dados.

---

# 📄 Licença

Este projeto foi desenvolvido apenas para fins acadêmicos.
