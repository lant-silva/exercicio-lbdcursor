USE master
GO
DROP DATABASE excursor2
GO

CREATE DATABASE excursor2
GO
USE excursor2
GO
create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2)
)
GO
create table endereço(
CPF varchar(20),
CEP varchar(10),
PORTA int,
ENDEREÇO varchar(200),
COMPLEMENTO varchar(100),
BAIRRO varchar(100),
CIDADE varchar(100),
UF Varchar(2)
)
GO
create procedure sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
while @cont1 <= @cont2 and @cont2 < = 100
begin
insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
values (cast(@cpf as varchar(20)), @cont1,GETDATE())
insert into endereço (CPF,PORTA,ENDEREÇO)
values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
set @cont1 = @cont1 + 1
set @conttotal = @conttotal + 1
if @cont1 > = @cont2
begin
set @cont1 = 1
set @cont2 = @cont2 + 1
set @cpf = @cpf + 1
end
end
GO
EXEC sp_insereenvio
GO
CREATE PROCEDURE sp_transferencia(@saida VARCHAR(100) OUTPUT)
AS
BEGIN
	DECLARE @nm_endereco VARCHAR(200),
			@nr_endereco INT,
			@nm_complemento VARCHAR(50),
			@nm_bairro VARCHAR(100),
			@nr_cep VARCHAR(10),
			@nm_cidade VARCHAR(100),
			@nm_uf VARCHAR(2)

	DECLARE cur CURSOR FOR
		SELECT CEP, PORTA, ENDEREÇO, COMPLEMENTO, BAIRRO, CIDADE, UF FROM endereço
	OPEN cur
	FETCH NEXT FROM cur INTO
		@nr_cep, @nr_endereco, @nm_endereco, @nm_complemento, @nm_bairro, @nm_cidade, @nm_uf
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE envio
		SET NR_CEP = @nr_cep,
			NR_ENDERECO = @nr_endereco,
			NM_ENDERECO = @nm_endereco,
			NM_COMPLEMENTO = @nm_complemento,
			NM_BAIRRO = @nm_bairro,
			NM_CIDADE = @nm_cidade,
			NM_UF = @nm_uf
		WHERE NR_LINHA_ARQUIV = CAST(SUBSTRING(@nm_endereco, CHARINDEX(' ', @nm_endereco) + 1, LEN(@nm_endereco)) AS INT)

	FETCH NEXT FROM cur INTO
		@nr_cep, @nr_endereco, @nm_endereco, @nm_complemento, @nm_bairro, @nm_cidade, @nm_uf
	END
	CLOSE cur
	DEALLOCATE cur
	SET @saida = 'Transferencia concluida'
END
GO

DECLARE @saida VARCHAR(200)
EXEC sp_transferencia @saida OUTPUT
PRINT @saida

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc
