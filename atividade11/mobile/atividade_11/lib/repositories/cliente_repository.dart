import 'dart:async';

import 'package:atividade11/models/Cliente.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ClienteRepository {

  Future<Database> getDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE clientes(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, sobrenome TEXT, cpf TEXT, observacao TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> inserir(Cliente cliente) async{
    final Database database = await getDatabase();

    await database.insert('clientes', cliente.toMap());
  }

  Future<void> atualizar(Cliente cliente) async{
    final Database database = await getDatabase();

    await database.update(
        'clientes',
        cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id]
    );
  }

  Future<List<Cliente>> obterTodos() async{
    final Database database = await getDatabase();

    final List<Map<String, dynamic>> clientes = await database.query('clientes');
    return List.generate(clientes.length, (i){
      return Cliente.fromJson(clientes[i]);
    });
  }

  Future<void> apagar(int id) async{
    final Database database = await getDatabase();

    await database.delete(
        'clientes',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}
