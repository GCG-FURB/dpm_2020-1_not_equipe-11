import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Comodo {
  String uid;
  String name;
  List<Ponto> pontos = new List();
  int quantidade_quedas;

  DocumentReference reference;

  // 3
  Comodo();

  // 4
  factory Comodo.fromJson(Map<dynamic, dynamic> json) => recordFromJson(json);

  // 5
  Map<String, dynamic> toJson() => recordToJson(this);

  //1
  static Comodo recordFromJson(Map<dynamic, dynamic> json) {
    var comodo = new Comodo();
    comodo.uid = json['uid'];
    comodo.name = json['name'];
    comodo.pontos = json['pontos'];
    comodo.quantidade_quedas = json['quantidade_quedas'];
    return comodo;
  }

  //2
  Map<String, dynamic> recordToJson(Comodo instance) {
    List<Map> pontos = this.pontos.map((e) => e.toJson()).toList();
    return {'name': instance.name, 'pontos': pontos, 'quantidade_quedas': quantidade_quedas};
  }

  factory Comodo.fromSnapshot(DocumentSnapshot snapshot) {
    Comodo r = Comodo.fromJson(snapshot.data);
    r.reference = snapshot.reference;
    return r;
  }

  @override
  String toString() => "Record<$uid>";

  getHigherPointer(String name) {
    var xMin = pontos.map((ponto) => ponto.x).reduce(min);
    var xMax = pontos.map((ponto) => ponto.x).reduce(max);
    var yMin = pontos.map((ponto) => ponto.y).reduce(min);
    var yMax = pontos.map((ponto) => ponto.y).reduce(max);

    var metade = name.length / 2;
    var deslocamento = metade * 11;
    var x = ((xMin + xMax) / 2) - deslocamento;
    return new Offset(x, ((yMin + yMax) / 2));
  }
}

class Ponto {
  double x;
  double y;

  Ponto(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}
