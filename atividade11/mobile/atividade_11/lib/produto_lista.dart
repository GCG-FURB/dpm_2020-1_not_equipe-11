import 'package:atividade11/produto_cadastro.dart';
import 'package:flutter/material.dart';

class ProdutoLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Produtos"),
        ),
        body: Container(
          child: Text('Olá mundo'),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:  (context) => ProdutoCadastro()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
