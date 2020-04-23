DROP TABLE clientes;

CREATE TABLE clientes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
    nome TEXT NOT NULL,
    sobrenome TEXT NOT NULL,
    cpf CHAR(14) NOT NULL,
    observacao TEXT,
    registro_ativo BIT NOT NULL
);

INSERT INTO clientes (nome, sobrenome, cpf, registro_ativo) VALUES 
('José', 'da Silva', '123.456.789-12', 1),
('Cecília', 'Gabrielly Giovana Freitas', '357.543.888-96', 1),
('Julio', 'Breno Fábio Alves', '632.606.475-97', 1),
('Renato', 'Pedro Porto', '968.223.142-61', 1),
('Edson', 'Cauã Leandro Barros', '044.056.185-00', 1),
('Heloise', 'Maya Aparício', '124.037.943-92', 1),
('Matheus', 'José Pires', '511.985.963-17', 1),
('Camila', 'Lara Josefa Alves', '296.555.187-52', 1),
('Enzo', 'Leonardo Rodrigues', '890.847.581-88', 1),
('Márcia', 'Laura Moreira', '867.662.810-65', 1),
('Malu', 'Lavínia Isabelly Vieira', '742.628.720-33', 1),
('Isabel', 'Sophia Souza', '871.420.862-89', 1),
('Clarice', 'Daniela Ferreira', '631.563.497-47', 1),
('Marlene', 'Sara Gabriela Galvão', '809.970.290-56', 1),
('Renan', 'Eduardo Guilherme Fernandes', '767.366.617-06', 1),
('Leonardo', 'Yuri Geraldo Caldeira', '481.853.402-18', 1),
('Isaac', 'Thiago Francisco Monteiro', '427.431.927-04', 1),
('Diego', 'Matheus Baptista', '468.007.332-29', 1),
('Andreia', 'Catarina Lima', '879.070.713-30', 1),
('Raimundo', 'João Pietro Lima', '156.889.691-30', 1),
('Sebastiana', 'Evelyn Duarte', '951.512.155-82', 1),
('Sebastião', 'Heitor Gustavo Carvalho', '057.260.898-55', 1),
('Severino', 'Lucca Felipe da Conceição', '153.028.261-60', 1),
('Joaquim', 'Ryan Bruno Caldeira', '647.452.192-96', 1),
('Juliana', 'Luana Martins', '704.870.261-36', 1),
('Letícia', 'Aline Carvalho', '132.001.849-14', 1),
('Benedita', 'Emilly Fogaça', '840.169.124-90', 1),
('Nelson', 'Manoel da Costa', '900.094.341-86', 1),
('Sebastião', 'Mateus Araújo', '364.564.223-45', 1),
('Bruno', 'Ruan Manuel Alves', '248.753.758-24', 1),
('Sophia', 'Tereza Nogueira', '115.602.552-42', 1);

DROP TABLE produtos;

CREATE TABLE produtos(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT NOT NULL,
    quantidade INT NOT NULL, 
    preco_unitario REAL NOT NULL,
    registro_ativo BIT NOT NULL
);

INSERT INTO produtos (nome, descricao, quantidade, preco_unitario, registro_ativo) VALUES 
('Xbox One X', 'Video Game da Microsoft', 3, 2000.90, 1),
('PS4 PRO', 'Video Game da Sony', 2, 2500, 1);

SELECT * FROM produtos;

SELECT * FROM clientes;