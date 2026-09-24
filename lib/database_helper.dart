import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  // Abre (ou cria, se não existe) o arquivo banco de dados
  static Future<Database> abrirBanco() async {
    final caminho = join(await getDatabasesPath(), 'tarefas.db');

    return openDatabase(
      caminho,
      version: 2,
      onCreate: (db, versao) {
        return db.execute(
          'CREATE TABLE tarefas ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'titulo TEXT,'
          'situacao INTEGER, ' // 0 - False, 1 - True
          'categoria TEXT'
          ')',
        );
      },
      onUpgrade: (db, versaoAntiga, versaoNova) {
        if (versaoAntiga < 2) {
          db.execute('ALTER TABLE tarefas ADD COLUMN categoria TEXT');
        }
      },
    );
  }

  // Getter que devolve o banco de dados já aberto, ou abre se ainda não existe
  static Future<Database> get database async {
    _db ??= await abrirBanco();

    return _db!;
  }

  // READ: Buscar todas as tarefas salvas no banco
  static Future<List<Map<String, dynamic>>> buscarTarefas({
    String? filtro,
  }) async {
    final db = await DatabaseHelper.database;

    if (filtro == 'pendentes') {
      return db.query(
        'tarefas',
        where: 'situacao = ?',
        whereArgs: [0],
      );
    }

    if (filtro == 'concluidas') {
      return db.query(
        'tarefas',
        where: 'situacao = ?',
        whereArgs: [1],
      );
    }

    return db.query('tarefas'); // SELECT * FROM tarefas
  }

  // CREATE: Inserir uma nova tarefa no banco de dados
  static Future<void> inserirTarefa(String titulo, String categoria) async {
    final db = await DatabaseHelper.database;
    await db.insert('tarefas', {
      'titulo': titulo,
      'situacao': 0,
      'categoria': categoria,
    });
  }

  // UPDATE: Atualizar a situação da tarefa
  static Future<void> atualizarTarefa(int id, int situacao) async {
    final db = await DatabaseHelper.database;

    await db.update(
      'tarefas',
      {'situacao': situacao},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE: Deletar uma tarefa do banco de dados
  static Future<void> deletarTarefa(int id) async {
    final db = await DatabaseHelper.database;

    await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
