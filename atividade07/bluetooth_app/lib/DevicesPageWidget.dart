import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DevicesPageWidget extends StatefulWidget {
  @override
  _DevicesPageWidgetState createState() => _DevicesPageWidgetState();
}

class _DevicesPageWidgetState extends State<DevicesPageWidget> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> _devices = [];

  _createListDevices() {
    List<Widget> list = [];
    
    if (_bluetoothState.isEnabled) {
      _getDevices();

      for (int i = 0; i < _devices.length; i++) {
        if (list.length > 0) {
          list.add(Divider());
        }
        
        list.add(ListTile(
          leading: Icon(Icons.device_unknown),
          title: Text(_devices[i].name),
          trailing: IconButton(
            icon: Icon(Icons.info),
            onPressed: () => _connectDevice(_devices[i]),
          ),
        ));
      }
    }

    return list;
  }

  _connectDevice(BluetoothDevice device) {
    FlutterBluetoothSerial.instance.isEnabled.then((isEnable) => {
      if (isEnable) {
        FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address)
      }
    });
  }

  void _getDevices() async {
    try {
      _devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } on PlatformException {
      print('Error');
    }
  }

  _onSwitchValueChanged(bool value) {
    future() async {
      if (value)
        await FlutterBluetoothSerial.instance.requestEnable();
      else
        await FlutterBluetoothSerial.instance.requestDisable();
    }

    future().then((_) {
      setState(() {});
    });

    FlutterBluetoothSerial.instance.state.then((state) => {
      setState(() {
        _bluetoothState = state;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: SwitchListTile(
                title: const Text('Enable bluetooth'),
                value: _bluetoothState.isEnabled,
                onChanged: _onSwitchValueChanged,
              ),
            ),
            Expanded(
              child: ListView(
                children: _createListDevices(),
              ),
            ),
          ],
        ),
      ],),
    );
  }

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) => {
      setState(() {
        _bluetoothState = state;
      })
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }
}