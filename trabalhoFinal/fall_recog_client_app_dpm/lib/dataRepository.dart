import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_recog_client_app/model/comodo.dart';
import 'package:fall_recog_client_app/model/queda_comodo.dart';
import 'package:fall_recog_client_app/model/record.dart';

class DataRepository {
  // 1
  final CollectionReference collection =
      Firestore.instance.collection('records');

  final CollectionReference collectionComodos =
      Firestore.instance.collection('comodos');

  final CollectionReference collectionQuedasComodos =
      Firestore.instance.collection('comodos_quedas');

  Stream<QuerySnapshot> getStreamComodos() {
    return collectionComodos.snapshots();
  }

  addComodo(Comodo comodo) async {
    var json = comodo.toJson();
    DocumentReference ref = await collectionComodos.add(json);
    return ref.documentID;
  }

  updateComodo(Comodo comodo) async {
    await collectionComodos.document(comodo.uid).updateData(comodo.toJson());
  }

  // 2
  Stream<QuerySnapshot> getStream() {
    return collection
        .where('queda', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamPositivos() {
    return collection
        .where('queda', isEqualTo: true)
        .where('positivo', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamByDay(DateTime day) {
    print(day);
    return collection
        .where('queda', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getLast() {
    return collection.orderBy('date', descending: true).limit(1).snapshots();
  }

  // 3
  //Future<DocumentReference> addPet(Pet pet) {
  //  return collection.add(pet.toJson());
  //}
  // 4
  update(Record r) async {
    await collection.document(r.reference.documentID).updateData(r.toJson());
  }

  deletePontos(first) async {
    await collection.document(first.uid).delete();
  }

  void addQuedaComodo(QuedaComodo quedaComodo) async{
    var json = quedaComodo.toJson();
    DocumentReference ref = await collectionQuedasComodos.add(json);
    print(ref.documentID);
  }

  Stream<QuerySnapshot> getQuedasByComodoId(String comodoId) {
    return collectionQuedasComodos
        .where('uidComodo', isEqualTo: comodoId)
        .snapshots();
  }
}
