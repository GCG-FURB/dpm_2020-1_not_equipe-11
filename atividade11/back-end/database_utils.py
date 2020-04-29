from sqlite3 import connect


def conectar():
    conexao = connect('projeto.db')
    return conexao
