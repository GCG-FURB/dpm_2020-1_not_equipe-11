import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PageHomeWidget extends StatefulWidget {
  BluetoothDevice _device;

  PageHomeWidget(BluetoothDevice device) {
    _device = device;
  }

  @override
  _PageHomeWidgetState createState() => _PageHomeWidgetState(_device);
}

class _PageHomeWidgetState extends State<PageHomeWidget> {
  BluetoothDevice _device;
  bool _switchValue = false;

  _PageHomeWidgetState(BluetoothDevice device) {
    _device = device;
  }

  _onSwitchChanged(value) {
    setState(() {
      _switchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SwitchListTile(
        title: Text('Enable Bluetooth'),
        value: _switchValue,
        onChanged: (value) => _onSwitchChanged(value),
      ),
    ],);
  }
}