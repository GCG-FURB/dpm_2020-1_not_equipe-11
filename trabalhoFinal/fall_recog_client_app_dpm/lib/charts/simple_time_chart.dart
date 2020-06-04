import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_recog_client_app/charts/queda_horario.dart';
import 'package:fall_recog_client_app/dataRepository.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class SimpleTimeChart extends StatefulWidget {
  @override
  _SimpleTimeChart createState() {
    return _SimpleTimeChart();
  }
}

class _SimpleTimeChart extends State<SimpleTimeChart> {
  List<charts.Series<QuedaHorario, DateTime>> _seriesBarData;
  List<QuedaHorario> mydata;
  final DataRepository repository = DataRepository();

  _generateData(mydata) {
    _seriesBarData = List<charts.Series<QuedaHorario, DateTime>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (QuedaHorario sales, _) => sales.horaDia,
        measureFn: (QuedaHorario sales, _) => sales.qtdQuedas,
        // colorFn: (QuedaDia sales, _) =>
        //     charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'QuedasHorario',
        data: mydata,
        labelAccessorFn: (QuedaHorario row, _) => "${row.horaDia}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getStreamPositivos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<QuedaHorario> sales =
              QuedaHorario.fromList(snapshot.data.documents);
          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<QuedaHorario> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Quedas por horário',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.TimeSeriesChart(_seriesBarData,
                   behaviors: [new charts.PanAndZoomBehavior()],
                    domainAxis: charts.DateTimeAxisSpec(
                      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                        hour: charts.TimeFormatterSpec(
                            format: 'H', transitionFormat: 'H'),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
