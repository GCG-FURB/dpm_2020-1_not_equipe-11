import 'dart:io';
import 'dart:ui';

import 'package:fall_recog_client_app/model/comodo.dart';
import 'package:flutter/material.dart';

import '../dataRepository.dart';

class ComodosWidget extends StatefulWidget {
  @override
  _ComodosWidgetState createState() => _ComodosWidgetState();
}

class _ComodosWidgetState extends State<ComodosWidget> {
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();

  List<Comodo> comodos = new List();
  var comodoAtual = new Comodo();
  final DataRepository repository = DataRepository();

  bool showBottomList = false;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanStart: (details) async {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth));

              adicionarPonto(details.globalPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: points,
            ),
          ),
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
            onPressed: () {
              abrirDialog();
            },
          ),
          visible: comodoAtual.pontos.length >= 3,
        ));
  }

  adicionarPonto(Offset globalPosition) {
    double x = globalPosition.dx;
    double y = globalPosition.dy;

    comodoAtual.pontos.add(new Ponto(x, y));
  }

  void abrirDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Informe o nome do cômodo'),
            content: new TextField(
              onChanged: (e) => comodoAtual.name = e,
              autofocus: true
            ),
            actions: <Widget>[
              new RaisedButton(
                onPressed: () => persistirInformacoes(),
                child: new Text('Salvar'),
                color: Colors.green,
                textColor: Colors.white,
              )
            ],
          );
        });
  }

  void persistirInformacoes() async {
    if(comodoAtual.name == null || comodoAtual.name.length == 0){
      var snackBar = SnackBar(content: Text('Campo deve ser preenchido'));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }

    await repository.addComodo(comodoAtual);
    Navigator.of(context).pop();

    comodoAtual = new Comodo();
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}
