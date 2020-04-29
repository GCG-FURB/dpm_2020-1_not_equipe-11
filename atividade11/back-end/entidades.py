class Cliente:
    def __init__(self, id, nome, sobrenome, cpf, observacao):
        self.id = id
        self.nome = nome
        self.sobrenome = sobrenome
        self.cpf = cpf
        self.observacao = observacao

class Produto:
    def __init__(self, id, nome, descricao, quantidade, valor_unitario):
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.quantidade = quantidade
        self.preco_unitario = valor_unitario