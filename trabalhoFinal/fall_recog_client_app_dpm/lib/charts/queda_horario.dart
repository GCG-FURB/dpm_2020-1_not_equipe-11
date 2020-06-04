import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QuedaHorario {
  final int qtdQuedas;
  final DateTime horaDia;  

  QuedaHorario(this.qtdQuedas, this.horaDia);

  static List<QuedaHorario> fromList(List<DocumentSnapshot> ds) {
    Map<int, int> quedasPorHorario = {};
    List.generate(24, (index) => index).forEach((element) => quedasPorHorario.putIfAbsent(element, () => 0));    
    for (DocumentSnapshot d in ds) {
      DateTime date = (d.data['date'] as Timestamp).toDate();
      int hour = date.hour;
      quedasPorHorario[hour] = quedasPorHorario[hour] + 1;
    }
    List<QuedaHorario> res = List();    
    var time = DateTime.now();    
    quedasPorHorario.forEach((key, value) => 
      res.add(QuedaHorario(value, new DateTime(time.year, time.month, time.day, key, time.minute, time.second, time.millisecond, time.microsecond)))
    );
    return res;
  } 

  // @override
  // String toString() => "Record<$saleVal:$saleYear:$colorVal>";
}
