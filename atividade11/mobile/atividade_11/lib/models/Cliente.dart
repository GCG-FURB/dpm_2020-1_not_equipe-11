class Cliente {
  int id;
  String nome;
  String sobrenome;
  String cpf;
  String observacao;

  Cliente({this.id, this.nome, this.sobrenome, this.cpf, this.observacao});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json['id'],
        nome: json['nome'],
        sobrenome: json['sobrenome'],
        cpf: json['cpf'],
        observacao: json['observacao']);
  }

  Map<String, String> toMap() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'observacao': observacao
    };
  }

  nomeCompleto() => nome + " " + sobrenome;

  @override
  String toString() {
    return 'Cliente{id: $id, nome: $nome, sobrenome: $sobrenome, cpf: $cpf, observacao: $observacao}';
  }
}
