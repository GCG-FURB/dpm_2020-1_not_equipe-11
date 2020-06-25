import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  var carregou = false;
  var pontosUids = List();

  List<DrawingPoints> pointsActual = List();

  List<Comodo> comodos = new List();
  var comodoAtual = new Comodo();
  final DataRepository repository = DataRepository();

  bool showBottomList = false;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: repository.getStreamComodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              parseComodos(snapshot.data);
              return new Column(children: <Widget>[]);
            },
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) async {
                desenharPonto(details);
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(pointsList: points, comodos: comodos),
              ),
            ),
          )
        ]),
        floatingActionButton: Visibility(
          child: getFloatingActionButton(),
          visible:
              comodoAtual.pontos.length >= 3 || comodoAtual.pontos.length == 0,
        ));
  }

  Widget getFloatingActionButton() {
    if (comodoAtual.pontos.length >= 3) {
      return FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
        onPressed: () {
          abrirDialog();
        },
      );
    } else {
      return Scaffold();
    }
  }

  void adicionarPontoLista(ponto) {
    points.add(DrawingPoints(
        points: ponto,
        paint: Paint()
          ..strokeCap = strokeCap
          ..isAntiAlias = true
          ..strokeWidth = strokeWidth));
  }

  void desenharPonto(details) {
    var offsetNewPointToDraw =
        new Offset(details.globalPosition.dx, details.globalPosition.dy);

    if (comodoAtual.pontos.length >= 1) {
      var lastPoint = comodoAtual.pontos.last;

      if (comodoAtual.pontos.length > 2) {
        setState(() {
          points.removeAt(points.length - 1);
          points.removeAt(points.length - 1);
        });
      }

      setState(() {
        points.add(null);
        adicionarPontoLista(new Offset(lastPoint.x, lastPoint.y));
        adicionarPontoLista(offsetNewPointToDraw);
        adicionarPonto(offsetNewPointToDraw);

        if (comodoAtual.pontos.length > 2) {
          var firstPoint = comodoAtual.pontos.first;
          adicionarPontoLista(new Offset(firstPoint.x, firstPoint.y));
        }

        points.add(null);
      });
    } else {
      setState(() {
        adicionarPontoLista(details.globalPosition);
        points.add(null);
        adicionarPonto(offsetNewPointToDraw);
      });
    }
  }

  void parseComodos(QuerySnapshot q) {
    if (!carregou) {
      q.documents.forEach((element) {
        var name = element.data['name'];
        List pontos = element.data['pontos'];

        var comodo = new Comodo();
        comodo.uid = element.documentID;
        comodo.name = name;
        comodo.quantidade_quedas = element.data['quantidade_quedas'];

        pontos.forEach((ponto) {
          var offset = new Offset(ponto["x"], ponto["y"]);
          adicionarPontoLista(offset);
          comodo.pontos.add(new Ponto(offset.dx, offset.dy));
        });

        var pontosFake = new List();
        pontosFake.add(comodo.pontos.first);
        pontosFake.add(comodo.pontos.last);
        fecharUltimoPonto(pontosFake);
        comodos.add(comodo);
        pontosUids.add(comodo.uid);

        points.add(null);
      });
      carregou = true;
    }
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
                onChanged: (e) => comodoAtual.name = e, autofocus: true),
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

  void apagarPontos() async {
    for (var i = 1; i < pontosUids.length; i++) {
      await repository.deletePontos(pontosUids[i]);
    }
  }

  void persistirInformacoes() async {
    if (comodoAtual.name == null || comodoAtual.name.length == 0) {
      var snackBar = SnackBar(content: Text('Campo deve ser preenchido'));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }

    comodoAtual.quantidade_quedas = 0;
    await repository.addComodo(comodoAtual);
    Navigator.of(context).pop();

    comodoAtual = new Comodo();
  }

  void fecharUltimoPonto(pontos) {
    var primeiroPonto = pontos.first;
    var offsetPrimerioPonto = new Offset(primeiroPonto.x, primeiroPonto.y);

    var ultimoPonto = pontos.last;
    var offsetUltimoPonto = new Offset(ultimoPonto.x, ultimoPonto.y);
    adicionarPontoLista(offsetPrimerioPonto);
    adicionarPontoLista(offsetUltimoPonto);
    points.add(null);
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList, this.comodos});

  List<Comodo> comodos;
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  void createTextSpan(String text, Canvas canvas, size, Offset offset) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 17,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var comodo in comodos) {
      var offset = comodo.getHigherPointer(comodo.name);
      createTextSpan(
          "${comodo.name} - ${comodo.quantidade_quedas}", canvas, size, offset);
    }

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
