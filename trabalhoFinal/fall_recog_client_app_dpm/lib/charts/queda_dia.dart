import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QuedaDia {
  final int qtdQuedas;
  final String diaSemana;

  static final List<String> diasSemana = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];

  QuedaDia(this.qtdQuedas, this.diaSemana);

  static List<QuedaDia> fromList(List<DocumentSnapshot> ds) {
    Map<String, int> quedasPorDia = {};
    diasSemana.forEach((e) => quedasPorDia.putIfAbsent(e, () => 0));    
    for (DocumentSnapshot d in ds) {
      DateTime date = (d.data['date'] as Timestamp).toDate();
      String weekDay = diasSemana[date.weekday - 1];
      quedasPorDia[weekDay] = quedasPorDia[weekDay] + 1;
    }
    List<QuedaDia> res = List();
    quedasPorDia.forEach((key, value) => res.add(QuedaDia(value, key)));
    return res;
  } 

  // @override
  // String toString() => "Record<$saleVal:$saleYear:$colorVal>";
}
