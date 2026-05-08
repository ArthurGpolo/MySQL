/* https://dontpad.com/guardadobd/ads_transportadora */
-- transportadora ADS
DROP SCHEMA IF EXISTS transportadora_ads ;
CREATE SCHEMA transportadora_ads ;
-- para ativar o banco acima
USE transportadora_ads ;
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 0;
-- tabela empresa contratante
DROP TABLE IF EXISTS empresa_contratante CASCADE ;
CREATE TABLE empresa_contratante (
 cod_contratante SMALLINT PRIMARY KEY ,
 rz_social_contratante VARCHAR(50) NOT NULL ,
cnpj_contratante NUMERIC(14,0) NOT NULL ,
end_contratante VARCHAR(100) NOT NULL,
fone NUMERIC(11) NOT NULL ) ;
-- verificando a estrutura --
DESCRIBE empresa_contratante ;
-- populando empresa
INSERT INTO empresa_contratante VALUES 
( 1, 'Grupo Pão de Açúcar' , 123456, 'Via Anchieta, 15000 - São Bernardo do Campo', 1150506060 ) ;
SELECT * FROM empresa_contratante ; 
-- atualizando o cnpj do Grupo Pão de Açúcar
UPDATE empresa_contratante
SET cnpj_contratante = 987654
WHERE cod_contratante = 1 ;
-- tabela armazém
DROP TABLE IF EXISTS armazem CASCADE ;
CREATE TABLE armazem (
 num_armazem SMALLINT PRIMARY KEY ,
 nome_amazem VARCHAR(50) NOT NULL ,
end_armazem VARCHAR(100) NOT NULL,
fone_armazem NUMERIC(11) NOT NULL ,
cod_contratante SMALLINT NOT NULL ,
FOREIGN KEY (cod_contratante) 
REFERENCES empresa_contratante (cod_contratante)
ON DELETE CASCADE ON UPDATE CASCADE ) ;
-- populando armazem
INSERT INTO armazem VALUES ( 10, 'Anchieta', 'Av Guido Aliberti , 1000 -
São Caetano do Sul', 1150554044, 1 ) ;
-- tabela motorista
DROP TABLE IF EXISTS motorista CASCADE ;
CREATE TABLE motorista (
cod_funcional TINYINT NOT NULL ,
nome_motorista VARCHAR(50) NOT NULL,
end_motorista VARCHAR(100) NOT NULL,
num_cnh INTEGER NOT NULL UNIQUE,
dt_validade_cnh DATE NOT NULL ,
categoria_cnh CHAR(1) NOT NULL ) ;
-- declarando a PK
ALTER TABLE motorista ADD PRIMARY KEY ( cod_funcional) ;
DESCRIBE motorista ;
-- adicionando novas colunas 
ALTER TABLE motorista ADD COLUMN sexo_motorista CHAR(1) NOT NULL,
ADD COLUMN dt_nascto_motorista DATE ;
-- criando restrição de verificação em sexo ( check constraint)
ALTER TABLE motorista ADD CHECK ( sexo_motorista IN ('M', 'F' ) ) ;
-- renomeando uma coluna
ALTER TABLE motorista RENAME COLUMN num_cnh TO numero_cnh ;
-- alterar o tipo de dado ou tamanho de uma coluna
ALTER TABLE motorista MODIFY COLUMN end_motorista VARCHAR(101) ;
-- criando e excluindo uma coluna
ALTER TABLE motorista ADD COLUMN usa_oculos BOOLEAN NOT NULL ;
-- populando motorista
DESCRIBE motorista ;
INSERT INTO motorista VALUES ( 100, 'Tereza Soares Teodoro',
' Praça Mauá, 2 - São Caetano do Sul', 123, current_date + INTERVAL '6' MONTH,
 'D', 'F', DATE('1995-10-25') , 1 ) ;
-- definindo NOT NULL para uma coluna
ALTER TABLE motorista MODIFY COLUMN dt_nascto_motorista DATE NOT NULL ;
-- excluindo uma coluna
ALTER TABLE motorista DROP COLUMN usa_oculos ;
-- tabela viagem
DROP TABLE IF EXISTS viagem CASCADE ;
CREATE TABLE viagem (
num_viagem INT AUTO_INCREMENT PRIMARY KEY ,
dt_hora_saida TIMESTAMP NOT NULL ,
dt_hora_retorno TIMESTAMP NULL ,
valor_frete NUMERIC(10,2) NOT NULL DEFAULT 0.0 ,
peso_total SMALLINT , 
volume_total SMALLINT,
km_percorridos SMALLINT , 
num_armazem_origem SMALLINT NOT NULL REFERENCES
armazem ( num_armazem) ON DELETE RESTRICT ON UPDATE CASCADE,
cod_func_motorista TINYINT NOT NULL REFERENCES
motorista ON DELETE RESTRICT ON UPDATE CASCADE ) ; 
DESCRIBE viagem ;
-- populando viagem
INSERT INTO viagem VALUES ( default, current_timestamp ,
null , default, 5000, 300, 486, 20, 100 ) ;
-- consulta para relacionar armazem e viagem
SELECT v.num_viagem, v.dt_hora_saida,
a.nome_amazem, a.num_armazem
FROM viagem v INNER JOIN armazem a 
ON ( v.num_armazem_origem = a.num_armazem) ;
-- consertando a FK 20 que não existe em armazém
DESCRIBE viagem ;
SELECT * FROM viagem ;
UPDATE viagem
SET num_armazem_origem = 10
WHERE num_armazem_origem = 20 ;

/**** Atividade 4
i)	Crie as tabelas em laranja: Depósito, Remessa e Caminhão;
ii)	Insira 3 linhas em cada tabela criada em i) ***/

-- tabela depósito
DROP TABLE IF EXISTS deposito CASCADE ;
CREATE TABLE deposito (
 num_depo SMALLINT PRIMARY KEY ,
 nome_depo VARCHAR(50) NOT NULL ,
end_depo VARCHAR(100) NOT NULL,
fone_depo NUMERIC(11) NOT NULL ,
cod_contratante SMALLINT NOT NULL ,
FOREIGN KEY (cod_contratante) 
REFERENCES empresa_contratante (cod_contratante)
ON DELETE CASCADE ON UPDATE CASCADE ) ;
-- populando deposito
INSERT INTO deposito VALUES ( 200, 'Vergueiro', 'Rua Vergueiro , 9000 -
São Paulo', 1137050408, 1 ) ;
INSERT INTO deposito VALUES ( 201, 'Taboão', 'Av do Taboão , 2000 -
São Bernardo do Campo', 1144050607, 1 ) ;
SELECT * FROM deposito ;

-- tabela caminhão 
DROP TABLE IF EXISTS caminhao CASCADE ;
CREATE TABLE caminhao (
num_licenca INTEGER PRIMARY KEY,
placa CHAR(7) NOT NULL UNIQUE ,
capacidade_kg INTEGER,
volume INTEGER ,
modelo VARCHAR(25) NOT NULL) ;
-- populando
DELETE FROM caminhao;
INSERT INTO caminhao VALUES ( 98765, 'FGH1H99' , 3000, 200, 'Truck Advanced') ,
( 314275, 'ABC1D99' , 4000, 500, 'Super Cargo') ;
SELECT * FROM caminhao ;

-- tabela Remessa
DROP TABLE IF EXISTS remessa CASCADE ;
CREATE TABLE remessa (
num_remessa INTEGER AUTO_INCREMENT PRIMARY KEY,
num_viagem INTEGER NOT NULL REFERENCES viagem
ON DELETE RESTRICT ON UPDATE CASCADE ,
volume_remessa INTEGER NOT NULL,
peso_remessa NUMERIC(5,1) NOT NULL,
tipo_carga VARCHAR(15) NOT NULL,
dt_hora_entrega_depo TIMESTAMP,
num_depo_destino SMALLINT NOT NULL 
REFERENCES deposito ON DELETE RESTRICT ON UPDATE CASCADE ) ;
-- populando viagem antes
INSERT INTO viagem VALUES ( default, current_timestamp + INTERVAL '30' MINUTE,
null , default, 2000, 200, 120 , 20, 100 ) ;
SELECT * FROM viagem ;
INSERT INTO remessa VALUES ( default, 1, 100, 50, 'CELULAR', null, 200 ) ;
INSERT INTO remessa VALUES ( default, 2, 150, 90, 'VESTUÁRIO', null, 201 ) ;

-- iii)	Nas tabelas criadas em sala de aula insira mais 2 linhas em cada;
INSERT INTO armazem VALUES ( 11, 'Pinheiros', 'Av Nações Unidas, 20000 -
São Paulo', 1150607000, 1 ) ;
INSERT INTO empresa_contratante VALUES 
( 2, 'Magazine Luiza' , 987654 , 'Rodovia Bandeirantes, km 77 - Itupeva', 1432706080 ) ;
INSERT INTO armazem VALUES ( 22, 'Lapa', 'Marginal Tietê, 3000 -
São Paulo', 1130227000, 2 ) ;
INSERT INTO deposito VALUES ( 202, 'Cotia', 'Av Cotia , 2000 -
Cotia', 1144220897, 2 ) ;
SELECT * FROM empresa_contratante ; -- 1 , 2
SELECT * FROM armazem ;  -- 10, 11, 22
SELECT * FROM deposito ; -- 200, 201, 202
-- motorista
INSERT INTO motorista VALUES ( 101, 'Rubinato Soares',
'Rua Gentil de Moura, 303 - apto 23 - São Paulo', 456, current_date + INTERVAL '20' MONTH,
 'D', 'M', DATE('1983-11-15') ) ;
INSERT INTO motorista VALUES ( 102, 'José Bento Madureira',
'Rua Sorocaba, 503 - apto 123 - São Paulo', 789, current_date + INTERVAL '3' MONTH,
 'D', 'M', DATE('1997-01-11') ) ;
SELECT * FROM motorista ;  -- 101, 102, 103
INSERT INTO caminhao VALUES ( 554421, 'ABC2D33' , 7000, 1200, 'Carga Pesada') ;
SELECT * FROM caminhao ; -- 98765 , 314275, 554421
INSERT INTO viagem VALUES ( default, current_timestamp + INTERVAL '200' MINUTE,
null , default, 3000, 300, 230 , 11, 102 ) ;
SELECT * FROM viagem ; -- 1, 2 , 3
INSERT INTO remessa VALUES ( default, 3, 300, 100, 'MOBILIÁRIO', null, 201 ) ;
SELECT * FROM remessa ;

-- iv)	Adicione as colunas marca, ano fabricação, quantidade de eixos e situação para Caminhão;
ALTER TABLE caminhao ADD COLUMN marca VARCHAR(20), 
ADD COLUMN ano_fabricacao SMALLINT , ADD COLUMN num_eixos TINYINT, 
ADD COLUMN situacao_caminhao VARCHAR(15) ;
UPDATE caminhao SET marca = 'Ford', ano_fabricacao = 2005, num_eixos = 4, situacao_caminhao = 'EM OPERAÇÃO'
WHERE num_licenca IN ( 98765 , 314275) ;
UPDATE caminhao SET marca = 'Scania', ano_fabricacao = 2015, num_eixos = 8, situacao_caminhao = 'EM OPERAÇÃO'
WHERE num_licenca = 554421 ;
-- v)	Na coluna situação em Caminhão, crie um check para os valores: “Em operação”, “Manutenção”, “”Inativo”. Atualize os dados das novas colunas criadas em iv ;
ALTER TABLE caminhao ADD CHECK 
( situacao_caminhao IN ('EM OPERAÇÃO', 'MANUTENÇÃO', 'INATIVO') ) ;
-- vi)	Renomeie alguma coluna em Remessa;
DESCRIBE remessa ;
ALTER TABLE remessa RENAME COLUMN tipo_carga TO tp_carga ;
-- vii)	Altere o tipo de dado para a coluna peso da remessa em Remessa.  */
ALTER TABLE remessa MODIFY COLUMN peso_remessa NUMERIC(6,2) ;

-- 1 - mostrar nome, numero, cnh e data nascimento dos motoristas do sexo feminino
SELECT nome_motorista AS motorista, numero_cnh AS cnh, dt_nascto_motorista AS "Data Nascimento" FROM motorista WHERE sexo_motorista = 'F';

-- 2 - mostrar placa, modelo, marca e situação do caminhão para os caminhões fabricados 
-- neste século que não da marca Volkswagen
SELECT placa, UPPER(modelo) AS modelo, LOWER(marca) AS marca, LOWER(situacao_caminhao) AS situação FROM caminhao WHERE ano_fabricacao >= 2000 AND marca != 'Volkswagen';

-- 3 - busca não exata LIKE, não utiliza igualdade
SELECT placa, UPPER(modelo) AS modelo, LOWER(marca) AS marca, LOWER(situacao_caminhao) AS situação, ano_fabricacao FROM caminhao WHERE ano_fabricacao BETWEEN 2010 AND 2026 AND marca NOT LIKE '%volks%';

-- 4 - motoristas que tem José no nome
SELECT nome_motorista, sexo_motorista, dt_nascto_motorista FROM motorista WHERE nome_motorista LIKE '%jos_ %';
-- começa com José
SELECT nome_motorista, sexo_motorista, dt_nascto_motorista FROM motorista WHERE nome_motorista LIKE 'jos_ %';
-- todos os motoristas que o sobrenome é Souza
SELECT nome_motorista, sexo_motorista, dt_nascto_motorista FROM motorista WHERE nome_motorista LIKE '% sou_a%';
-- motoristas que residem em São Caetano ou São Paulo 
SELECT nome_motorista, sexo_motorista, dt_nascto_motorista, end_motorista FROM motorista WHERE end_motorista LIKE '%s_o caetano%' OR end_motorista LIKE '%s_o paulo%';

-- 5 - funções de data - datas do sistema
SELECT current_date AS Data_atual , current_timestamp AS "Data hora atual", now() AS "Similar ao current_timestamp", curdate(), curtime() AS Hora;

-- 6 - função EXTRACT que extrai pedações da data ou hora 
SELECT EXTRACT(YEAR FROM current_date) AS ano, EXTRACT(MONTH FROM current_date) AS mês_atual, EXTRACT(WEEK FROM current_timestamp) AS semana_ano, EXTRACT(HOUR FROM now()) - 1 AS uma_hora_atrás, EXTRACT(MINUTE FROM now()) AS minuto;

-- 7 - viagens realizadas esse mês 
SELECT * FROM viagem WHERE EXTRACT(MONTH FROM dt_hora_saida) = EXTRACT(MONTH FROM current_date);

-- 8 - INTERVAL -> adiciona ou subtrai intervalos de tempo a uma data ou hora
SELECT current_date + INTERVAL '7' DAY AS "Próxima aula", current_timestamp - INTERVAL '100' MINUTE + INTERVAL '1' HOUR, current_date - INTERVAL '3' MONTH AS "Três meses atrás";

-- 9 - motoristas com idade superior a 25 anos
SELECT nome_motorista, dt_nascto_motorista, TRUNCATE(DATEDIFF(current_date, dt_nascto_motorista) / 365.25, 0) AS idade_motorista FROM motorista WHERE dt_nascto_motorista <= current_date - INTERVAL '25' YEAR; 

-- Dados de mais de uma tabela - operação de junção interna - JOIN 

-- 10 - mostrar o número da viagem, data de saida, nome do motorista e numero da cnh
SELECT num_viagem, dt_hora_saida, nome_motorista, numero_cnh FROM viagem, motorista WHERE cod_func_motorista = cod_funcional; -- FK com a PK













