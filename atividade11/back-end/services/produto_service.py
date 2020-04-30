from database_utils import conectar
from entidades import Produto


def obter_todos():
    conexao = conectar()
    cursor = conexao.execute('SELECT id, nome, descricao, quantidade, preco_unitario FROM produtos WHERE registro_ativo = 1 ORDER BY nome')

    produtos = []
    for row in cursor:
        id = row[0]
        nome = row[1]
        descricao = row[2]
        quantidade = row[3]
        preco_unitario = row[4]
        produtos.append(Produto(id, nome, descricao, quantidade, preco_unitario))
    return produtos


def inserir(produto: Produto):
    conexao = conectar()
    cursor = conexao.cursor()
    data_tuple = (produto.nome, produto.descricao, produto.quantidade, produto.preco_unitario)
    cursor.execute(f'INSERT INTO produtos (nome, descricao, quantidade, preco_unitario, registro_ativo) VALUES (?,?,?,?, 1)', data_tuple)
    conexao.commit()
    return cursor.lastrowid


def alterar(produto: Produto):
    conexao = conectar()
    cursor = conexao.cursor()
    data_tuple = (produto.nome, produto.descricao, produto.quantidade, produto.preco_unitario, produto.id)
    cursor.execute(f'UPDATE produtos SET nome=?, descricao=?, quantidade=?, preco_unitario=? WHERE id=?', data_tuple)
    conexao.commit()


def apagar(id: int):
    conexao = conectar()
    cursor = conexao.cursor()
    cursor.execute(f'UPDATE produtos SET registro_ativo=0 WHERE id={id}')
    conexao.commit()


def obter_pelo_id(id: int):
    conexao = conectar()
    cursor = conexao.execute(f'SELECT id, nome, descricao, quantidade, preco_unitario FROM produtos WHERE registro_ativo = 1 AND id = {id}')

    for row in cursor:
        id = row[0]
        nome = row[1]
        descricao = row[2]
        quantidade = row[3]
        preco_unitario = row[4]
        return Produto(id, nome, descricao, quantidade, preco_unitario)

    return None
