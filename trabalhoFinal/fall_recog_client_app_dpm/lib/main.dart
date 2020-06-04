import 'package:flutter/material.dart';
import 'widget/home_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(App()));
}

const BoldStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fall detection DPM',     
        home: Home());
  }
}
