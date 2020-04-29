class Produto {
  final int id;
  final String nome;
  final int quantidade;
  final double precoUnitario;
  final String descricao;

  Produto({this.id, this.nome, this.quantidade, this.precoUnitario, this.descricao});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
        id: json['id'],
        nome: json['nome'],
        quantidade: json['quantidade'],
        precoUnitario:  json['preco_unitario'],
        descricao: json['descricao']);
  }
}
