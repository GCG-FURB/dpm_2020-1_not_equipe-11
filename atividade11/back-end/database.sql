DROP TABLE clientes;

CREATE TABLE clientes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
    nome TEXT NOT NULL,
    sobrenome TEXT NOT NULL,
    cpf CHAR(14) NOT NULL,
    observacao TEXT,
    registro_ativo BIT NOT NULL
);

INSERT INTO clientes (nome, sobrenome, cpf, registro_ativo) VALUES ('José', 'da Silva', '123.456.789-12', 1);

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