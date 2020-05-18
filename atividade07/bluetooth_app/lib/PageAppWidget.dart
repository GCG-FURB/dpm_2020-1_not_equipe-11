import 'package:bluetoothapp/PageDevicesWidget.dart';
import 'package:bluetoothapp/PageHomeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PageAppWidget extends StatefulWidget {
  List<BluetoothDevice> _devices = [];

  PageAppWidget(List<BluetoothDevice> devices) {
    _devices = devices;
  }

  @override
  _PageAppWidgetState createState() => _PageAppWidgetState(_devices);
}

class _PageAppWidgetState extends State<PageAppWidget> {
  List<BluetoothDevice> _devices = [];
  int _selectedIndex = 0;

  _PageAppWidgetState(List<BluetoothDevice> devices) {
    _devices = devices;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getPageItemTapped() {
    if (_selectedIndex == 0) {
      return PageDevicesWidget(_devices);
    } else if (_selectedIndex == 1) {
      return PageHomeWidget(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth App'),
      ),
      body: Container(
        child: _getPageItemTapped(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
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
        onTap: _onItemTapped,
      ),
    );
  }
}