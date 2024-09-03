import 'package:lista_tarefas_sqlite_2024_2/repositories/sqlite_database.dart';
import '../models/tarefa.dart';

class Repositorio {
  static Future<List<Tarefa>> recuperarTudo() async {
    SqliteDatabase sqliteDatabase = SqliteDatabase();
    final database = await sqliteDatabase.obterDataBase();
    final resultado = await database.rawQuery("SELECT * from tarefas");
    List<Tarefa> tarefas = [];
    for (var elemento in resultado) {
      tarefas.add(Tarefa(
          id: int.parse(elemento["id"].toString()),
          nome: elemento["nome"].toString(),
          realizado:
              int.parse(elemento["realizado"].toString()) == 1 ? true : false),
          );
    }
    return tarefas;
  }

  static Future<Tarefa> adicionarTarefa(Tarefa tarefa) async {
    SqliteDatabase sqliteDatabase = SqliteDatabase();
    final database = await sqliteDatabase.obterDataBase();
    int id = await database.rawInsert("INSERT into tarefas (nome, realizado) "
        "VALUES (?,?)",
        [tarefa.nome,tarefa.realizado]);
    tarefa.id = id;
    return tarefa;
  }

  static Future<void> atualizarTarefa(Tarefa tarefa) async {
    SqliteDatabase sqliteDatabase = SqliteDatabase();
    final database = await sqliteDatabase.obterDataBase();
    await database.rawUpdate("UPDATE tarefas SET nome = ?, realizado = ?"
        "WHERE id = ?",[tarefa.nome, tarefa.realizado,tarefa.id]);
  }

  static Future<void> deletarTarefa(Tarefa tarefa) async {
    SqliteDatabase sqliteDatabase = SqliteDatabase();
    final database = await sqliteDatabase.obterDataBase();
    int numeroMudancas = await database.rawDelete("DELETE FROM tarefas WHERE id = ?", [tarefa.id]);
  }
}
