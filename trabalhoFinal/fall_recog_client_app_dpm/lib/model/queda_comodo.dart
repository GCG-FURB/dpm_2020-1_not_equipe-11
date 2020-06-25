import 'package:cloud_firestore/cloud_firestore.dart';

class QuedaComodo {
  String uid;
  String uidComodo;
  String uidQueda;

  DocumentReference reference;

  QuedaComodo();

  factory QuedaComodo.fromJson(Map<dynamic, dynamic> json) =>
      recordFromJson(json);

  Map<String, dynamic> toJson() => recordToJson(this);

  //1
  static QuedaComodo recordFromJson(Map<dynamic, dynamic> json) {
    var quedaComodo = new QuedaComodo();
    quedaComodo.uid = json['uid'];
    quedaComodo.uidComodo = json['uidComodo'];
    quedaComodo.uidQueda = json['uidQueda'];
    return quedaComodo;
  }

  //2
  Map<String, dynamic> recordToJson(QuedaComodo instance) {
    return {'uidQueda': instance.uidQueda, 'uidComodo': instance.uidComodo};
  }

  factory QuedaComodo.fromSnapshot(DocumentSnapshot snapshot) {
    QuedaComodo r = QuedaComodo.fromJson(snapshot.data);
    r.reference = snapshot.reference;
    return r;
  }

  @override
  String toString() => "Record<$uid>";
}
