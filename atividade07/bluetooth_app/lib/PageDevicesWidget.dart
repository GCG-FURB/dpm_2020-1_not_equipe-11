import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PageDevicesWidget extends StatefulWidget {
  List<BluetoothDevice> _devices = [];

  PageDevicesWidget(List<BluetoothDevice> devices) {
    _devices = devices;
  }

  @override
  _PageDevicesWidgetState createState() => _PageDevicesWidgetState(_devices);
}

class _PageDevicesWidgetState extends State<PageDevicesWidget> {
  List<BluetoothDevice> _devices = [];
  bool _switchValue = false;

  _PageDevicesWidgetState(List<BluetoothDevice> devices) {
    _devices = devices;
  }

  _onSwitchValueChanged(bool value) {
    setState(() {
      _switchValue = value;
    });
  }

  _tapCallBack() {

  }

  _buildRows() {
    List<ListTile> rows = [];

    if (_devices.length == 0) {
      rows.add(ListTile(
        title: Text(
          'Not devices',
          style: const TextStyle(fontSize: 18.0),
        ),
      ));
    } else {
      for (int i = 0; i < _devices.length; i++) {
        rows.add(ListTile(
          title: Text(
            _devices[i].name,
            style: const TextStyle(fontSize: 18.0),
          ),
          leading: const Icon(Icons.device_unknown),
          dense: true,
          onTap: () => _tapCallBack(),
        ));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildRows(),
        ),
      ),
    ],);
  }
}