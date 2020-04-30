from database_utils import conectar
from entidades import Cliente


def obter_todos():
    conexao = conectar()
    cursor = conexao.execute('SELECT id, nome, sobrenome, cpf, observacao FROM clientes WHERE registro_ativo = 1 ORDER BY nome, sobrenome')

    clientes = []
    for row in cursor:
        id = row[0]
        nome = row[1]
        sobrenome = row[2]
        cpf = row[3]
        observacao = row[4]
        clientes.append(Cliente(id, nome, sobrenome, cpf, observacao))
    return clientes


def inserir(cliente: Cliente):
    conexao = conectar()
    cursor = conexao.cursor()
    data_tuple = (cliente.nome, cliente.sobrenome, cliente.cpf, cliente.observacao)
    cursor.execute(f'INSERT INTO clientes (nome, sobrenome, cpf, observacao, registro_ativo) VALUES (?,?,?,?, 1)', data_tuple)
    conexao.commit()
    return cursor.lastrowid


def alterar(cliente: Cliente):
    conexao = conectar()
    cursor = conexao.cursor()
    data_tuple = (cliente.nome, cliente.sobrenome, cliente.cpf, cliente.observacao, cliente.id)
    cursor.execute(f'UPDATE clientes SET nome=?, sobrenome=?, cpf=?, observacao=? WHERE id=?', data_tuple)
    conexao.commit()


def apagar(id: int):
    conexao = conectar()
    cursor = conexao.cursor()
    cursor.execute(f'UPDATE clientes SET registro_ativo=0 WHERE id={id}')
    conexao.commit()


def obter_pelo_id(id):
    conexao = conectar()
    cursor = conexao.execute(f'SELECT id, nome, sobrenome, cpf, observacao FROM clientes WHERE registro_ativo = 1 AND id = {id}')

    for row in cursor:
        id = row[0]
        nome = row[1]
        sobrenome = row[2]
        cpf = row[3]
        observacao = row[4]
        return Cliente(id, nome, sobrenome, cpf, observacao)

    return None