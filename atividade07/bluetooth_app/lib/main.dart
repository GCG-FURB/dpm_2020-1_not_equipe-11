import 'package:bluetoothapp/DevicesPageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(BluetoothAppWidget());

class BluetoothAppWidget extends StatefulWidget {
  @override
  _BluetoothAppWidgetState createState() => _BluetoothAppWidgetState();
}

class _BluetoothAppWidgetState extends State<BluetoothAppWidget> {
  int _selectedIndex = 1;

  void _onSelectedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getPageItemTapped() {
    if (_selectedIndex == 0) {
      return DevicesPageWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth App'),
          centerTitle: true,
        ),
        body: _getPageItemTapped(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.devices),
              title: Text('Devices'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Message'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onSelectedItem,
        ),
      ),
    );
  }
}