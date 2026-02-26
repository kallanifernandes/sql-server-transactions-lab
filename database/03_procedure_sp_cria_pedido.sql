CREATE PROCEDURE SP_CRIA_PEDIDO 
(
	@NOME_CLIENTE		VARCHAR(255)
	,@NOME_VENDEDOR		VARCHAR(255)
	,@NOME_PRODUTO		VARCHAR(255)
	,@QUANTIDADE		INT
)
AS
BEGIN

	SET NOCOUNT ON; --MOSTRA A QUANTIDADE DE LINHA AFETADA

	DECLARE  @CLIENTE		INT
	;DECLARE @VENDEDOR		INT
	;DECLARE @PRODUTO		INT
	;DECLARE @PRECO			DECIMAL(15,2)
	;DECLARE @ESTOQUE       INT
	;DECLARE @NEW_PEDIDO    INT
	
	BEGIN TRY
		BEGIN TRAN

			---------------------------------------
			--Atualiza campos cliente
			---------------------------------------
			SELECT
				@CLIENTE = CLIENTE
			FROM 
				CLIENTES
			WHERE 
				NOME = @NOME_CLIENTE;

			---------------------------------------
			--Atualiza campos vendedor
			---------------------------------------
			SELECT 
				@VENDEDOR = VENDEDOR
			FROM 
				VENDEDORES
			WHERE 
				NOME = @NOME_VENDEDOR;
				
			---------------------------------------
			--Atualiza campos produtos
			---------------------------------------
			SELECT
				@PRODUTO   = PRODUTO
				,@PRECO   = PRECO
				,@ESTOQUE = ESTOQUE
			FROM 
				PRODUTOS
			WHERE 
				NOME = @NOME_PRODUTO;

			
			---------------------------------------
			--Verificações Iniciais
			---------------------------------------
			IF @CLIENTE IS NULL
				THROW 5000, 'Cliente não encontrado', 1;

			IF @VENDEDOR IS NULL
				THROW 5001, 'Vendedor não encontrado', 1;

			IF @PRODUTO IS NULL 
				THROW 5002, 'Produto não encontrado', 1;

			IF @ESTOQUE < @QUANTIDADE 
				THROW 5003, 'Estoque Insuficiente', 1;


			---------------------------------------
			--Insere na Pedidos
			---------------------------------------
			INSERT INTO PEDIDOS(CLIENTE, VENDEDOR, STATUS)
			VALUES (@CLIENTE, @VENDEDOR, 'PENDENTE');

			SET @NEW_PEDIDO = SCOPE_IDENTITY();

			---------------------------------------
			--Insere na Itens_pedido
			---------------------------------------
			INSERT INTO ITENS_PEDIDO(PEDIDO, PRODUTO, QUANTIDADE, VALOR_UNITARIO)
			VALUES (@NEW_PEDIDO, @PRODUTO, @QUANTIDADE, @PRECO);

			--Atualiza o ESTOQUE

			UPDATE PRODUTOS
			SET ESTOQUE = ESTOQUE - @QUANTIDADE
			WHERE PRODUTO = @PRODUTO;

			COMMIT;

		END TRY
		BEGIN CATCH
			ROLLBACK;
				PRINT ERROR_MESSAGE();
		END CATCH
END;
