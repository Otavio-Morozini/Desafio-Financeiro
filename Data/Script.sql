-- Script SQL para criação do banco de dados e tabelas do Desafio Técnico

USE master;
GO

-- Criar banco de dados se não existir
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DesafioDB')
BEGIN
    CREATE DATABASE DesafioDB;
END
GO

USE DesafioDB;
GO

-- Criar tabela Lancamentos se não existir
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Lancamentos')
BEGIN
    CREATE TABLE Lancamentos (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Descricao VARCHAR(250) NOT NULL,
        Tipo VARCHAR(10) NOT NULL, -- 'Credito' ou 'Debito'
        ValorOriginal DECIMAL(18, 2) NOT NULL,
        PercentualTaxa DECIMAL(5, 2) NOT NULL,
        PercentualDesconto DECIMAL(5, 2) NOT NULL,
        ValorCalculado DECIMAL(18, 2) NOT NULL,
        DataLancamento DATETIME NOT NULL,
        DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
        DataPagamento DATETIME NULL,
        DataCancelamento DATETIME NULL,
        Competencia VARCHAR(7) NOT NULL, -- formato 'MM/AAAA'
        Status VARCHAR(15) NOT NULL -- 'Aberto', 'Pago', 'Cancelado'
    );

    -- Inserir dados fictícios iniciais para demonstração
    INSERT INTO Lancamentos (Descricao, Tipo, ValorOriginal, PercentualTaxa, PercentualDesconto, ValorCalculado, DataLancamento, Competencia, Status, DataPagamento)
    VALUES 
    ('Serviço de Consultoria', 'Credito', 1500.00, 0.00, 5.00, 1425.00, GETDATE(), RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)), 2) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)), 'Pago', GETDATE()),
    ('Licença de Software', 'Debito', 300.00, 2.50, 0.00, 307.50, GETDATE(), RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)), 2) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)), 'Pago', GETDATE()),
    ('Assinatura Mensal Cloud', 'Debito', 150.00, 1.50, 0.00, 152.25, GETDATE(), RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)), 2) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)), 'Aberto', NULL),
    ('Desenvolvimento Mobile', 'Credito', 5000.00, 0.00, 10.00, 4500.00, GETDATE(), RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)), 2) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)), 'Aberto', NULL);
END
GO
