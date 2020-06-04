import 'package:flutter/material.dart';

class ConfigWidget extends StatefulWidget {
  @override
  _ConfigWidgetState createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
        ),
        body: new Column());
  }
}
