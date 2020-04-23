class Cliente {
  final int id;
  final String nome;
  final String sobrenome;
  final String cpf;
  final String observacao;

  Cliente({this.id, this.nome, this.sobrenome, this.cpf, this.observacao});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json['id'],
        nome: json['nome'],
        sobrenome: json['sobrenome'],
        cpf:  json['cpf'],
        observacao: json['observacao']);
  }

  nomeCompleto() => nome + " " + sobrenome;
}
