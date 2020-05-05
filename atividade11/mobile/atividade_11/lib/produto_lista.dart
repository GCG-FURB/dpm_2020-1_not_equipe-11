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
        body: Container(child: MyProductList()));
  }
}

class MyProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductListState();
}

class _ProductListState extends State<MyProductList> {
  Future<List<Produto>> futureProduto;
  List<Produto> produtos;

  @override
  void initState() {
    super.initState();
    futureProduto = fetchProdutos();
  }

  irParaTelaCadastro(BuildContext context) async {
    Produto produto = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProdutoCadastro(null)));
    if (produto != null) {
      produtos.add(produto);
      produtos.sort((a, b) => a.nome.compareTo(b.nome));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => irParaTelaCadastro(context),
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Produto>>(
          future: futureProduto,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              produtos = snapshot.data;

              return ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(produtos[index].nome),
                      child: InkWell(
                          onTap: () {
                            print("${produtos[index]} clicked");
                          },
                          child: ListTile(
                              title: Text(produtos[index].nome),
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProdutoCadastro(produtos[index])));
                              })),
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await ApresentarModalApagar(context, index);
                      } else {
                        Produto produto = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProdutoCadastro(produtos[index])));
                      }
                    },
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Future<bool> ApresentarModalApagar(BuildContext context, int index) async {
    final bool res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                "Deseja realmente apagar o produto ${produtos[index].nome}?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Apagar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // TODO: Delete the item from DB etc..
                  apagarProdutos(produtos[index].id, produtos, index);
                },
              ),
            ],
          );
        });
    return res;
  }

  Future<List<Produto>> apagarProdutos(id, produtos, index) async {
    final response = await http.delete('http://10.0.2.2:5000/produtos/$id');

    if (response.statusCode == 200) {
      setState(() {
        produtos.removeAt(index);
      });
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get('http://10.0.2.2:5000/produtos');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Produto> produtos =
          body.map((dynamic item) => Produto.fromJson(item)).toList();
      return produtos;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Widget slideLeftBackground() {
    return Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 20),
              Icon(Icons.delete, color: Colors.white),
              Text(
                'Editar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                textAlign: TextAlign.right,
              )
            ],
          ),
          alignment: Alignment.centerRight,
        ));
  }

  Widget slideRightBackground() {
    return Container(
        color: Colors.green,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 20),
              Icon(Icons.edit, color: Colors.white),
              Text(
                'Editar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              )
            ],
          ),
          alignment: Alignment.centerLeft,
        ));
  }
}
