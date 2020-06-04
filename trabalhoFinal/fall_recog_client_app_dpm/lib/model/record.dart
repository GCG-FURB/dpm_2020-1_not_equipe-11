import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  // 1
  String uid;
  DateTime date;
  bool queda;
  bool positivo;
  // 2
  DocumentReference reference;
  // 3
  Record(this.uid, {this.date, this.queda, this.reference, this.positivo});
  // 4
  factory Record.fromJson(Map<dynamic, dynamic> json) => recordFromJson(json);
  // 5
  Map<String, dynamic> toJson() => recordToJson(this);

  //1
  static Record recordFromJson(Map<dynamic, dynamic> json) {
    return Record(
      json['uid'] as String,
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
      queda: json['queda'] as bool,
      positivo: json['positivo'] as bool,
    );
  }

//2
  Map<String, dynamic> recordToJson(Record instance) => <String, dynamic>{
        'uid': instance.uid,
        'date': instance.date,
        'queda': instance.queda,
        'positivo': instance.positivo
      };

  factory Record.fromSnapshot(DocumentSnapshot snapshot) {
    Record r = Record.fromJson(snapshot.data);
    r.reference = snapshot.reference;
    return r;
  }
  
  @override
  String toString() => "Record<$uid>";
}
