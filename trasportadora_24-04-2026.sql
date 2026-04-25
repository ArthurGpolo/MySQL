-- Transportadora - ADS
CREATE SCHEMA IF NOT EXISTS transportadora_ads ;

-- Para ativar o banco acima
USE transportadora_ads;

-- Evitar erros de FK
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS empresa_contratante CASCADE;
-- Tabela empresa contratante
CREATE TABLE empresa_contratante(
	cod_contratante				SMALLINT 			PRIMARY KEY,
    rz_social_contratante		VARCHAR(50)			NOT NULL,
    cnpj_contratante			NUMERIC(14, 0)		NOT NULL UNIQUE,
    endereco_contratante		VARCHAR(100)		NOT NULL,
    telefone_contratante		NUMERIC(11, 0)		NOT NULL
); 

-- Verificando a estrutura
DESCRIBE empresa_contratante;

-- Populando empresa
INSERT INTO empresa_contratante 
(cod_contratante, rz_social_contratante, cnpj_contratante, endereco_contratante, telefone_contratante)
VALUES
	(1, 'Grupo Pão de Açucar', 123456, 'Via Anchieta, 15000 - São Bernardo do Campo', '1150506060')
;

-- Conferindo se empresa foi populada
SELECT * FROM empresa_contratante; 

-- Atualizando o cnpj do Grupo Pão de Açucar
UPDATE empresa_contratante 
SET cnpj_contratante = 987654
WHERE cod_contratante = 1;

DROP TABLE IF EXISTS armazem CASCADE;
-- Tabela armazém
CREATE TABLE armazem(
	num_armazem					SMALLINT 			AUTO_INCREMENT PRIMARY KEY,
	nome_armazem				VARCHAR(50)			NOT NULL,
    endereco_armazem			VARCHAR(100)		NOT NULL,
    telefone_armazem			NUMERIC(11, 0)		NOT NULL,
    cod_contratante				SMALLINT			NOT NULL,
    
    -- Chaves estrangeiras
    FOREIGN KEY (cod_contratante) REFERENCES empresa_contratante (cod_contratante)
    ON DELETE CASCADE ON UPDATE CASCADE -- RESTRICT
);

-- Verificando a estrutura
DESCRIBE armazem;

-- Populando armazem
INSERT INTO armazem 
(nome_armazem, endereco_armazem, telefone_armazem, cod_contratante)
VALUES
	 ('Anchieta', 'Av Guido Aliberti , 1000 - São Caetano do Sul', 1150554044, 1 ) ;
;

-- Conferindo se empresa foi populada
SELECT * FROM armazem; 

DROP TABLE IF EXISTS motorista CASCADE;
-- Tabela motorista
CREATE TABLE motorista(
	cod_funcional			TINYINT 			,
    nome_motorista			VARCHAR(50)			NOT NULL,
    endereco_motorista		VARCHAR(100)		NOT NULL,
    num_cnh					INTEGER 			NOT NULL UNIQUE,
    dt_validade_cnh			DATE 				NOT NULL,
    cetegoria_cnh			CHAR(1)				NOT NULL
);

-- Verificando a estrutura
DESCRIBE motorista;

-- Declarando a PK 
ALTER TABLE motorista ADD PRIMARY KEY (cod_funcional);

-- Adicionando novas colunas 
ALTER TABLE motorista 
ADD COLUMN sexo_motorista CHAR(1) NOT NULL,
ADD COLUMN dt_nascto_motorista DATE;

-- Criando restrição de verificação em sexo (check constraint)
ALTER TABLE motorista ADD CHECK (sexo_motorista IN ('M', 'F'));

-- Renomeando uma coluna
ALTER TABLE motorista RENAME COLUMN num_cnh TO numero_cnh;

-- Alterar o tipo de dado ou tamanho de uma coluna
ALTER TABLE motorista MODIFY COLUMN endereco_motorista VARCHAR(101);

-- Criando e excluindo uma coluna
ALTER TABLE motorista ADD COLUMN usa_oculos BOOLEAN NOT NULL;

-- Populando motorista
INSERT INTO motorista
VALUES
	 (100, 'Tereza Soares Teodoro', ' Praça Mauá, 2 - São Caetano do Sul', 123, current_date + INTERVAL '6' MONTH, 'D', 'F', DATE('1995-10-25') , 1 ) ;
;

-- Conferindo se motorista foi populada
SELECT * FROM motorista; 

-- Definindo NOT NULL para uma coluna
ALTER TABLE motorista MODIFY COLUMN dt_nascto_motorista DATE NOT NULL;

-- Definindo uma coluna
ALTER TABLE motorista DROP COLUMN usa_oculos;

DROP TABLE IF EXISTS viagem CASCADE;
-- Table viagem
CREATE TABLE viagem(
	num_viagem				INT					AUTO_INCREMENT PRIMARY KEY,
    dt_hora_saida			TIMESTAMP			NOT NULL,
    dt_hora_retorno			TIMESTAMP			,
    valor_frete				NUMERIC(10, 2)		NOT NULL DEFAULT 0.0,
    peso_total				SMALLINT			,
    volume_total			SMALLINT			,
    km_percorridos			SMALLINT			,
    num_armazem_origem		SMALLINT			NOT NULL REFERENCES armazem (num_armazem) ON DELETE RESTRICT ON UPDATE CASCADE, -- FK
    cod_func_motorista		TINYINT				NOT NULL REFERENCES motorista ON DELETE RESTRICT ON UPDATE CASCADE -- FK
);

-- Verificando a estrutura
DESCRIBE viagem;

-- Populando viagem
INSERT INTO viagem
VALUES
	(default, current_timestamp, null, default, 5000, 300, 486, 20, 100)
;

-- Conferindo se viagem foi populada
SELECT * FROM viagem; 

-- Consulta para relacionar armazem e viagem
SELECT v.num_viagem, v.dt_hora_saida,
a.nome_amazem, a.num_armazem
FROM viagem v INNER JOIN armazem a 
ON ( v.num_armazem_origem = a.num_armazem) ;

-- Consertando a FK 20 que não existe em armazém
UPDATE viagem
SET num_armazem = 10
WHERE num_armazem_origem = 20;
