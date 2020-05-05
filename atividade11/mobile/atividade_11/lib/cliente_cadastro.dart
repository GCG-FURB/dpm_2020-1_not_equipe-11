import 'package:atividade11/models/Cliente.dart';
import 'package:atividade11/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ClienteCadastro extends StatelessWidget {
  Cliente cliente;

  ClienteCadastro(Cliente cliente) {
    if (cliente == null)
      this.cliente = new Cliente();
    else
      this.cliente = cliente;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de Cliente"),
        ),
        body: ClienteCadastroStatefulWidget(cliente));
  }
}

class ClienteCadastroStatefulWidget extends StatefulWidget {
  Cliente cliente;

  ClienteCadastroStatefulWidget(Cliente cliente) {
    this.cliente = cliente;
  }

  @override
  _ClientWidgetState createState() {
    return _ClientWidgetState(cliente);
  }
}

class _ClientWidgetState extends State<ClienteCadastroStatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: '000.000.000-00');
  ClienteRepository repository;

  Cliente cliente;

  _ClientWidgetState(Cliente cliente) {
    this.cliente = cliente;
    repository = new ClienteRepository();
    this.controller.updateText(cliente.cpf);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Nome', hintText: 'Informar o nome'),
                      autovalidate: true,
                      initialValue: cliente.nome,
                      onSaved: (String value) => cliente.nome = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nome não pode ser vazio';
                        }

                        if (value.length < 3) {
                          return 'Nome deve conter no mínimo 3 caracteres';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Sobrenome',
                          hintText: 'Informar o sobrenome'),
                      autovalidate: true,
                      initialValue: cliente.sobrenome,
                      onSaved: (String value) => cliente.sobrenome = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Sobrenome não pode ser vazio';
                        }

                        if (value.length < 3) {
                          return 'Sobrenome deve conter no mínimo 3 caracteres';
                        }

                        return null;
                      },
                    ),
                    Text('CPF', textAlign: TextAlign.start),
                    new TextField(
                        controller: controller,
                        onSubmitted: (String value) => this.cliente.cpf = value,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ]),
                    TextFormField(
                      minLines: 1,
                      maxLines: 10,
                      onSaved: (String value) =>
                          this.cliente.observacao = value,
                      decoration:
                          const InputDecoration(labelText: 'Observação'),
                      validator: (value) {
                        return null;
                      },
                    ),
                    RaisedButton(
                      onPressed: () => salvar(),
                      child: Text('Salvar'),
                    ),
                  ],
                ))));
  }

  salvar() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      this.cliente.cpf = controller.text;


      if(cliente.id == null){
        await repository.inserir(cliente);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Registro inserido com sucesso"),
        ));
        Navigator.pop(context, cliente);
      }
      else{
        await repository.atualizar(cliente);

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Registro alterado com sucesso"),
        ));
        Navigator.pop(context, cliente);
      }
    }
  }
}
