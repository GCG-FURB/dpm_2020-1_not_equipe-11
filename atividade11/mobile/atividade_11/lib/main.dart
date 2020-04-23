import 'package:atividade11/produto_lista.dart';
import 'package:flutter/material.dart';

import 'cliente_lista.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Atividade 11';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        RaisedButton(
          child: Text('Clientes'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ClienteLista()));
          },
        ),
        RaisedButton(
          child: Text('Produtos'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProdutoLista()));
          },
        ),
      ],
    ));
  }
}
