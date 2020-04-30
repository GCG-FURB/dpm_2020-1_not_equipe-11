import 'dart:convert';

import 'package:atividade11/models/Produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ProdutoCadastro extends StatelessWidget {

  Produto produto;

  ProdutoCadastro(Produto produto){
    this.produto = produto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de Produto"),
        ),
        body: ProdutoStatefulWidget(produto));
  }
}

class ProdutoStatefulWidget extends StatefulWidget {
  Produto produto;

  ProdutoStatefulWidget(Produto produto){
    this.produto = produto;
  }
  
  @override
  State<StatefulWidget> createState() => _ProdutoWidgetState(produto);
}

class _ProdutoWidgetState extends State<ProdutoStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Produto produto;

  _ProdutoWidgetState(Produto produto){
    if(produto == null)
      this.produto = Produto();
    else
      this.produto = produto;
  }

  void submit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      salvarProduto();
    }
  }

  Future<Produto> salvarProduto() {
    if(produto.id == null){
      inserirProduto();
    }else{
      alterarProduto();
    }
  }

  alterarProduto() async{
    final body = jsonEncode(<String, String>{
      'id': produto.id.toString(),
      'nome': produto.nome,
      'descricao': produto.descricao,
      'quantidade': produto.quantidade.toString(),
      'preco_unitario':
      produto.precoUnitario.toString()
    });
    final response = await http.put('http://10.0.2.2:5000/produtos/alterar',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Produto alterado com sucesso"),
      ));
      Navigator.pop(context, produto);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Falha ao salvar"),
      ));
    }
  }

  inserirProduto() async{
    final body = jsonEncode(<String, String>{
      'nome': produto.nome,
      'descricao': produto.descricao,
      'quantidade': produto.quantidade.toString(),
      'preco_unitario':
      produto.precoUnitario.toString()
    });
    final response = await http.post('http://10.0.2.2:5000/produtos/inserir',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Salvo com sucesso"),
      ));
      Navigator.pop(context, produto);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Falha ao salvar"),
      ));
    }
  }

  validateNome(String value) {
    if (value.isEmpty) {
      return 'Nome não pode ser vazio';
    }

    if (value.length < 3) {
      return 'Nome deve conter no mínimo 3 caracteres';
    }

    return null;
  }

  validateQuantidade(String value) {
    if (value.isEmpty) {
      return 'Quantidade não pode ser vazio';
    }
    return null;
  }

  validatePrecoUnitario(String value) {
    if (value.isEmpty) {
      return 'Preço unitário não pode ser vazio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: produto?.nome,
                        decoration: const InputDecoration(
                            labelText: 'Nome', hintText: 'Informar o nome'),
                        onSaved: (String value) {
                          this.produto.nome = value;
                        },
                        validator: (value) => validateNome(value)),
                    TextFormField(
                      initialValue: produto?.descricao,
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      onSaved: (String value) {
                        produto.descricao = value;
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: produto?.quantidade?.toString(),
                        decoration: const InputDecoration(
                            labelText: 'Quantidade',
                            hintText: 'Informar a quantidade'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onSaved: (String value) {
                          produto.quantidade = int.parse(value);
                        },
                        validator: (value) => validateQuantidade(value)),
                    TextFormField(
                      initialValue: produto?.precoUnitario?.toString(),
                      decoration: const InputDecoration(
                          labelText: 'Preço Unitário',
                          hintText: 'Informar o preço unitário'),
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        var valor = value.replaceAll(',', '');
                        produto.precoUnitario = double.parse(valor);
                      },
                      validator: (value) => validatePrecoUnitario(value),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: () => submit(),
                          child: Text('Salvar'),
                        ))
                  ],
                ))));
  }
}
