import 'package:atividade11/cliente_cadastro.dart';
import 'package:atividade11/models/Cliente.dart';
import 'package:atividade11/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class ClienteLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Clientes"),
        ),
        body: Container(child: MyClienteLista()));
  }
}

class MyClienteLista extends StatefulWidget {
  @override
  _ClienteListaState createState() => new _ClienteListaState();
}

class _ClienteListaState extends State<MyClienteLista> {
  Future<List<Cliente>> futureCliente;
  ClienteRepository repository;

  List<Cliente> clientes;

  _ClienteListaState() {
    repository = new ClienteRepository();
  }

  @override
  void initState() {
    super.initState();
    futureCliente = fetchClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Cliente cliente = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ClienteCadastro(null)));
          if (cliente != null) {
            clientes.add(cliente);
            clientes.sort((a, b) => a.nome.compareTo(b.nome));
          }
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Cliente>>(
        future: futureCliente,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Cliente> clientes = snapshot.data;
            return ListView(
                children: clientes
                    .map((cliente) => ListTile(
                          title: Text(cliente.nomeCompleto()),
                          onLongPress: () => dialogApagar(cliente),
                          onTap: () async => await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClienteCadastro(cliente))),
                        ))
                    .toList());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<Cliente>> fetchClientes() async {
    clientes = await repository.obterTodos();
    return clientes;
  }

  apagarCliente(Cliente cliente) async {
    await repository.apagar(cliente.id);
    clientes.removeWhere((aux) => aux.id == cliente.id);
    Navigator.of(context).pop();
    setState(() {});
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Produto apagado com sucesso"),
    ));
  }

  dialogApagar(Cliente cliente) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Deseja realmente apagar o produto ${cliente.nome}?"),
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
                  apagarCliente(cliente);
                },
              ),
            ],
          );
        });
  }
}
