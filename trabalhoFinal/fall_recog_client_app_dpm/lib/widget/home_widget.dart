import 'package:fall_recog_client_app/widget/comodos_widget.dart';
import 'package:fall_recog_client_app/widget/historico_widget.dart';
import 'package:fall_recog_client_app/widget/stats_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; 

  final List<Widget> _children = [
    HistoricoWidget(),
    StatsWidget(),
    ComodosWidget(),
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('Histórico - DPM'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Estatísticas - DPM'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Cômodos - DPM'),
          )           
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
