import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_recog_client_app/model/record.dart';

class DataRepository {
  // 1
  final CollectionReference collection = Firestore.instance.collection('records');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.where('queda', isEqualTo: true)
                     .orderBy('date', descending: true)
                     .snapshots();
  }

  Stream<QuerySnapshot> getStreamPositivos() {
    return collection.where('queda', isEqualTo: true)
                     .where('positivo', isEqualTo: true)
                     .orderBy('date', descending: true)
                     .snapshots();
  }

  Stream<QuerySnapshot> getStreamByDay(DateTime day) {
    print(day);
    return collection.where('queda', isEqualTo: true)
                     .orderBy('date', descending: true)
                     .snapshots();
  }

  Stream<QuerySnapshot> getLast() {
    return collection.orderBy('date', descending: true)
                     .limit(1)
                     .snapshots();
  }  
  
  // 3
  //Future<DocumentReference> addPet(Pet pet) {
  //  return collection.add(pet.toJson());
  //}
  // 4
  update(Record r) async {
    await collection.document(r.reference.documentID).updateData(r.toJson());
  }  
}