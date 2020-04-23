import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ClienteCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de Cliente"),
        ),
        body: MyStatefulWidget());
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _ClientWidgetState createState() {
    return _ClientWidgetState();
  }
}

class _ClientWidgetState extends State<MyStatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: '000.000.000-00');

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Nome', hintText: 'Informar o nome'),
              autovalidate: true,
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
                  labelText: 'Sobrenome', hintText: 'Informar o sobrenome'),
              autovalidate: true,
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
            ),
            TextFormField(
              minLines: 1,
              maxLines: 10,
              decoration: const InputDecoration(labelText: 'Observação'),
              validator: (value) {
                return null;
              },
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Salvo com sucesso"),
                  ));
                }
              },
              child: Text('Salvar'),
            ),
          ],
        )));
  }
}
