import 'package:cloud_firestore/cloud_firestore.dart';

class Comodo {
  String uid;
  String name;
  List<Ponto> pontos = new List();

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
    return comodo;
  }

//2
  Map<String, dynamic> recordToJson(Comodo instance){
    List<Map> pontos = this.pontos.map((e) => e.toJson()).toList();
   return {
        'name': instance.name,
        'pontos': pontos
      };
  }

  factory Comodo.fromSnapshot(DocumentSnapshot snapshot) {
    Comodo r = Comodo.fromJson(snapshot.data);
    r.reference = snapshot.reference;
    return r;
  }

  @override
  String toString() => "Record<$uid>";
}

class Ponto {
  int x;
  int y;

  Ponto(int x, int y) {
    this.x = x;
    this.y = y;
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}
