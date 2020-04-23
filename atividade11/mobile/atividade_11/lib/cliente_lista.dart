import 'dart:convert';

import 'package:atividade11/cliente_cadastro.dart';
import 'package:atividade11/models/Cliente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClienteLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Clientes"),
      ),
      body: Container(
          child: MyClienteLista()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ClienteCadastro()));
        },
        child: Icon(Icons.add),
      ),
    );
  }


}

class MyClienteLista extends StatefulWidget {
  @override
  _ClienteListaState createState() => new _ClienteListaState();

}

class _ClienteListaState extends State<MyClienteLista> {

  Future<List<Cliente>> futureCliente;

  @override
  void initState() {
    super.initState();
    futureCliente = fetchClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Cliente>>(
          future: futureCliente,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Cliente> clientes = snapshot.data;
              return ListView(
                children: clientes.map((cliente)  => ListTile(
                  title: Text(cliente.nomeCompleto()),
                )).toList()
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
    );
  }


  Future<List<Cliente>> fetchClientes() async {
    final response = await http.get('http://10.0.2.2:5000/clientes');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Cliente> clientes = body.map((dynamic item) => Cliente.fromJson(item)).toList();
      return clientes;
    } else {
      throw Exception('Failed to load clients');
    }
  }
}
