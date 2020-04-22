from flask import Flask, abort
app = Flask(__name__)
from json import dumps

from database_utils import conectar
from entidades import Cliente
from services.cliente_service import obter_todos, obter_pelo_id

@app.route("/clientes/")
def index():
    clientes = obter_todos()
    print(clientes)
    return dumps([cliente.__dict__ for cliente in clientes])

@app.route("/clientes/<int:id>")
def get_by_id(id):
    cliente = obter_pelo_id(id)
    if cliente is None:
        return abort(404)

    return dumps(cliente.__dict__)

if __name__ == '__main__':
    app.run()