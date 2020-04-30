from flask import Flask, abort, request
from _sqlite3 import Error
from entidades import Cliente, Produto

app = Flask(__name__)
from json import dumps
import services.cliente_service as cliente_service
import services.produto_service as produto_service


@app.route("/clientes", methods=['GET'])
def cliente_get_all():
    clientes = cliente_service.obter_todos()
    return dumps([cliente.__dict__ for cliente in clientes])


@app.route("/clientes/<int:id>", methods=['GET'])
def cliente_get_by_id(id):
    cliente = cliente_service.obter_pelo_id(id)
    if cliente is None:
        return abort(404)

    return dumps(cliente.__dict__)


@app.route("/clientes/<int:id>", methods=['DELETE'])
def cliente_apagar(id):
    try:
        cliente_service.apagar(id)
        return {'status': True}
    except Error:
        return {'status': False}


@app.route('/clientes/inserir', methods=['POST'])
def cliente_insert():
    dados = request.get_json()
    nome = dados['nome']
    sobrenome = dados['sobrenome']
    cpf = dados['cpf']
    observacao = dados['observacao']
    cliente = Cliente(0, nome, sobrenome, cpf, observacao)
    id = cliente_service.inserir(cliente)
    retorno = {'id': id}
    return retorno


@app.route('/clientes/alterar', methods=['PUT'])
def cliente_update():
    try:
        dados = request.get_json()
        id = dados['id']
        nome = dados['nome']
        sobrenome = dados['sobrenome']
        cpf = dados['cpf']
        observacao = dados['observacao']
        cliente = Cliente(id, nome, sobrenome, cpf, observacao)
        cliente_service.alterar(cliente)
        return {'status': True}
    except Error:
        return {'status': False}


@app.route("/produtos", methods=['GET'])
def produto_get_all():
    produtos = produto_service.obter_todos()
    return dumps([produto.__dict__ for produto in produtos])


@app.route("/produtos/<int:id>", methods=['GET'])
def produto_get_by_id(id):
    produto = produto_service.obter_pelo_id(id)
    if produto is None:
        return abort(404)

    return dumps(produto.__dict__)


@app.route("/produtos/<int:id>", methods=['DELETE'])
def produto_apagar(id):
    try:
        produto_service.apagar(id)
        return {'status': True}
    except Error:
        return {'status': False}


@app.route('/produtos/inserir', methods=['POST'])
def produto_insert():
    dados = request.get_json()
    nome = dados['nome']
    descricao = dados['descricao']
    quantidade = dados['quantidade']
    preco_unitario = dados['preco_unitario']
    produto = Produto(0, nome, descricao, quantidade, preco_unitario)
    id = produto_service.inserir(produto)
    retorno = {'id': id}
    return retorno


@app.route('/produtos/alterar', methods=['PUT'])
def produto_update():
    try:
        dados = request.get_json()
        id = dados['id']
        nome = dados['nome']
        descricao = dados['descricao']
        quantidade = dados['quantidade']
        preco_unitario = dados['preco_unitario']
        produto = Produto(id, nome, descricao, quantidade, preco_unitario)
        produto_service.alterar(produto)
        return {'status': True}
    except Error:
        return {'status': False}


if __name__ == '__main__':
    app.run()
