//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_recog_client_app/dataRepository.dart';
import 'package:fall_recog_client_app/model/comodo.dart';
import 'package:fall_recog_client_app/model/queda_comodo.dart';
import 'package:fall_recog_client_app/model/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoricoWidget extends StatefulWidget {
  HistoricoWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HistoricoWidget createState() => _HistoricoWidget();
}

class _HistoricoWidget extends State<HistoricoWidget>
    with TickerProviderStateMixin {
  DateTime _selectedDay;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool _deveMostrar;
  final DataRepository repository = DataRepository();
  List<Comodo> comodos = new List();
  var _comodoSelecionado;
  var carregou = false;

  @override
  void initState() {
    super.initState();
    _comodoSelecionado = "Escolha um cômodo";
    DateTime time = DateTime.now();
    time = new DateTime.utc(
        time.year,
        time.month,
        time.day,
        12,
        0,
        0,
        0,
        0);

    _selectedDay = time;
    _calendarController = CalendarController();
    _deveMostrar = true;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last,
      CalendarFormat format) {
    setState(() {
      _deveMostrar = _calendarController.visibleDays.contains(_selectedDay);
    });
  }

  void _onCalendarCreated(DateTime first, DateTime last,
      CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico - DPM'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: repository.getStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final events = parseEvent(snapshot.data);
              return Expanded(
                  child: Column(
                    children: <Widget>[
                      buildCalendar(events),
                      const SizedBox(height: 8.0),
                      Center(
                          child: _deveMostrar
                              ? Text(
                              'Quedas - ' +
                                  DateFormat('dd/MM').format(_selectedDay),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold))
                              : Text("")),
                      const SizedBox(height: 8.0),
                      _buildEventList(_deveMostrar ? events[_selectedDay] : [])
                    ],
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget buildCalendar(Map events) {
    return TableCalendar(
      locale: 'pt_BR',
      calendarController: _calendarController,
      events: events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue[400],
        todayColor: Colors.blue[400],
        markersColor: Colors.brown[700],
        weekendStyle: TextStyle().copyWith(color: Colors.black),
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.black),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          var eventos = events == null ? [] : events;
          var gradient = (eventos.length * 100);
          var color = Colors.red[gradient];
          if (gradient > 400) {
            color = Colors.red;
          }
          return Container(
              height: 80,
              width: 80,
              color: color,
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              child: Text('${date.day}'));
        },
        selectedDayBuilder: (context, date, events) {
          var eventos = events == null ? [] : events;
          var gradient = (eventos.length * 100);
          var color = Colors.red[gradient];
          if (gradient > 400) {
            color = Colors.red;
          }
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(border: Border.all(), color: color),
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, events) {
          var eventos = events == null ? [] : events;
          var gradient = (eventos.length * 100);
          var color = Colors.red[gradient];
          if (gradient > 400) {
            color = Colors.red;
          }
          return Container(
              decoration:
              BoxDecoration(border: Border.all(width: 3), color: color),
              height: 80,
              width: 80,
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              child: Text('${date.day}'));
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // color: _calendarController.isSelected(date)
        //     ? Colors.brown[500]
        //     : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
        color: Colors.brown[500],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Map<DateTime, List> parseEvent(QuerySnapshot q) {
    Map<DateTime, List> _events = Map();
    q.documents.forEach((element) {
      DateTime time = (element.data['date'] as Timestamp).toDate();
      time = new DateTime.utc(
          time.year,
          time.month,
          time.day,
          12,
          0,
          0,
          0,
          0);
      _events.update(time, (list) => list..add(element),
          ifAbsent: () => [element]);
    });
    return _events;
  }

  Widget _buildEventList(List<dynamic> list) {
    if (list == null || list.isEmpty) {
      return const SizedBox(height: 8.0);
    }
    return Expanded(
        child: GridView.count(
          crossAxisCount: 4,
          children: list.map((data) => _buildListItem(context, data)).toList(),
        ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    return Card(
      color: getStatus(snapshot),
      child: InkWell(
          onTap: () {
            updateStatus(snapshot);
          },
          onLongPress: () {
            abrirDialog(snapshot.documentID);
          },
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(6),
                child: Center(
                    child: Text(DateFormat('HH:mm').format(
                        (snapshot.data['date'] as Timestamp).toDate())))),
            Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Center(child: getAsset(snapshot))),
          ])),
    );
  }

  Color getStatus(DocumentSnapshot event) {
    if (event.data['positivo'] == null) {
      return Colors.white;
    }
    if (event.data['positivo']) {
      return Colors.red[300];
    }
    return Colors.green[300];
  }

  Widget getAsset(DocumentSnapshot event) {
    if (event.data['positivo'] == null) {
      return null;
    }
    if (event.data['positivo']) {
      return Image(image: AssetImage('assets/falling.png'));
    }
    return Image(image: AssetImage('assets/standing.png'));
  }

  void updateStatus(DocumentSnapshot d) {
    Record r = Record.fromSnapshot(d);
    if (r.positivo == null) {
      r.positivo = true;
    } else {
      r.positivo = !r.positivo;
    }
    d.data['positivo'] = r.positivo;
    repository.update(r);
  }

  void parseComodos(QuerySnapshot q) async {
    comodos = new List();
    q.documents.forEach((element) {
      var name = element.data['name'];
      var comodo = new Comodo();
      comodo.uid = element.documentID;
      comodo.name = name;
      comodo.quantidade_quedas = element.data['quantidade_quedas'];

      List pontos = element.data['pontos'];
      pontos.forEach((ponto) {
        var offset = new Offset(ponto["x"], ponto["y"]);
        comodo.pontos.add(new Ponto(offset.dx, offset.dy));
      });
      comodos.add(comodo);
    });
  }

  void abrirDialog(String documentID) {
    carregou = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Informe o nome do cômodo'),
            content: StreamBuilder<QuerySnapshot>(
                stream: repository.getStreamComodos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return buildDropdowComodoList(snapshot.data);
                }),
            actions: <Widget>[
              new RaisedButton(
                child: new Text('Salvar'),
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  persistirColisaoComComodo(documentID);
                },
              )
            ],
          );
        });
  }

  Widget buildDropdowComodoList(data) {
    if (!carregou) {
      parseComodos(data);
      carregou = true;
    }

    return Column(children: <Widget>[
      new DropdownButton<String>(
          hint: Text('Escolha um cômodo'),
          value: _comodoSelecionado,
          onChanged: (newValue) {
            setState(() {
              _comodoSelecionado = newValue;
            });
          },
          items: gerarListaComodosDropdown()),
    ]);
  }

  gerarListaComodosDropdown() {
    List<DropdownMenuItem<String>> dropdownMenuItens = new List();
    dropdownMenuItens.add(new DropdownMenuItem<String>(
      value: "Escolha um cômodo",
      child: new Container(
        child: new Text("Escolha um cômodo"),
        width: 200.0,
      ),
    ));

    for (Comodo comodo in comodos) {
      dropdownMenuItens.add(new DropdownMenuItem<String>(
        value: comodo.name,
        child: new Container(
          child: new Text(comodo.name),
          width: 200.0,
        ),
      ));
    }
    return dropdownMenuItens;
  }

  void persistirColisaoComComodo(String quedaId) async {
    var comodo =
        comodos
            .where((element) => element.name == _comodoSelecionado)
            .first;

    var quedaComodo = new QuedaComodo();
    quedaComodo.uidQueda = quedaId;
    quedaComodo.uidComodo = comodo.uid;
    repository.addQuedaComodo(quedaComodo);

    comodo.quantidade_quedas += 1;
    repository.updateComodo(comodo);

    Navigator.of(context).pop();
    setState(() {
      _comodoSelecionado = "Escolha um cômodo";
    });
  }
}
