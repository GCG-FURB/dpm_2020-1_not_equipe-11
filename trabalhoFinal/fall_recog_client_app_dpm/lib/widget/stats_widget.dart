import 'package:fall_recog_client_app/charts/simple_bar_chart.dart';
import 'package:fall_recog_client_app/charts/simple_time_chart.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas - DPM"),        
      ),
      body: new Column(        
        children: <Widget> [
          Container(
            height: 320,
            child: SimpleBarChart()
          ),
          Container(
            height: 320,
            child: SimpleTimeChart()
          )
          
        ]
      )
    );
  } 
}
