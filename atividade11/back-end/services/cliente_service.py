from database_utils import conectar
from entidades import Cliente

def obter_todos():
    conexao = conectar()
    cursor = conexao.execute('SELECT id, nome, sobrenome, cpf, observacao FROM clientes WHERE registro_ativo = 1')

    clientes = []
    for row in cursor:
        id = row[0]
        nome = row[1]
        sobrenome = row[1]
        cpf = row[2]
        observacao = row[3]
        clientes.append(Cliente(id, nome, sobrenome, cpf, observacao))
        print(nome)
    return clientes



def obter_pelo_id(id):
    conexao = conectar()
    cursor = conexao.execute(f'SELECT id, nome, sobrenome, cpf, observacao FROM clientes WHERE registro_ativo = 1 AND id = {id}')

    for row in cursor:
        id = row[0]
        nome = row[1]
        sobrenome = row[1]
        cpf = row[2]
        observacao = row[3]
        return Cliente(id, nome, sobrenome, cpf, observacao)

    return None