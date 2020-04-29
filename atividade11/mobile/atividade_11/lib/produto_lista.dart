import 'dart:convert';

import 'package:atividade11/produto_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/Produto.dart';

class ProdutoLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Produtos"),
      ),
      body: Container(child: MyProductList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProdutoCadastro()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProductListState();
}

class _ProductListState extends State<MyProductList> {
  Future<List<Produto>> futureProduto;


  @override
  void initState() {
    super.initState();
    futureProduto = fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Produto>>(
          future: futureProduto,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Produto> produtos = snapshot.data;
              return ListView(
                  children: produtos.map((produto) =>
                      ListTile(
                        title: Text(produto.nome),
                      ))
                      .toList());
            } else if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            return CircularProgressIndicator();
          },
        )
    );
  }

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get('http://10.0.2.2:5000/produtos');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Produto> produtos = body.map((dynamic item) =>
          Produto.fromJson(item)).toList();
      return produtos;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
