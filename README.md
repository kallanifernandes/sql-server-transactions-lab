# SQL Server Transactions Lab

Projeto prático desenvolvido para aprofundamento em Stored Procedures, controle transacional e integridade de dados no SQL Server.

## Objetivo

Após identificar oportunidades de melhoria em processos internos no ambiente de trabalho, desenvolvi este laboratório com o objetivo de:

- Reforçar conceitos de transações (ACID)
- Implementar regras de negócio diretamente no banco
- Trabalhar com tratamento de erros (TRY/CATCH e THROW)
- Garantir integridade no controle de estoque
- Simular um fluxo real de criação de pedidos

---

## Estrutura do Projeto
- 01_create_tables.sql
- 02_insert_data.sql
- 03_procedure_sp_cria_pedido.sql
- 04_query_validacao.sql

  
---

## 🗄 Modelagem

O projeto simula um sistema de vendas contendo:

- CLIENTES
- VENDEDORES
- PRODUTOS
- PEDIDOS
- ITENS_PEDIDO

Relacionamentos:

- Pedido pertence a um Cliente
- Pedido pertence a um Vendedor
- Pedido possui um ou mais Itens
- Produto tem controle de estoque

---

## Procedure Implementada

### SP_CRIA_PEDIDO

A procedure executa:

1. Busca IDs com base nos nomes informados
2. Valida existência de Cliente, Vendedor e Produto
3. Verifica estoque disponível
4. Inicia transação
5. Insere registro em PEDIDOS
6. Insere registro em ITENS_PEDIDO
7. Atualiza estoque
8. Realiza COMMIT
9. Em caso de erro, executa ROLLBACK

### Recursos Utilizados

- SET NOCOUNT ON
- BEGIN TRY / BEGIN CATCH
- BEGIN TRAN / COMMIT / ROLLBACK
- THROW para erros personalizados
- SCOPE_IDENTITY()
- Validação de estoque

---

##  Query de Validação

Após executar a procedure, utilizei a seguinte consulta para validar os registros:

```sql
SELECT 
    D.NOME        AS CLIENTE,
    E.NOME        AS VENDEDOR,
    C.NOME        AS PRODUTO,
    C.ESTOQUE     AS ESTOQUE_ATUAL,
    C.PRECO
FROM ITENS_PEDIDO A
JOIN PEDIDOS      B ON A.PEDIDO   = B.PEDIDO
JOIN PRODUTOS     C ON A.PRODUTO  = C.PRODUTO
JOIN CLIENTES     D ON B.CLIENTE  = D.CLIENTE
JOIN VENDEDORES   E ON B.VENDEDOR = E.VENDEDOR
WHERE A.PEDIDO = 31;
