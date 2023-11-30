import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quiz/JsonModels/note_model.dart';
import 'package:quiz/JsonModels/users.dart';

class DatabaseHelper {
  String noteTable =
      "CREATE TABLE IF NOT EXISTS  notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  String users =
      "create table IF NOT EXISTS  users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  //We are done in this section

  Future<Database> initDB({required String databaseName}) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(noteTable);
    });
  }

  //Login Method
  Future<bool> login(Users user) async {
    final Database db = await initDB(databaseName: 'users');
    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB(databaseName: 'users');
    return db.insert('users', user.toMap());
  }

//exist user
  Future<bool> doesUserExist(String usrName) async {
    final Database db = await initDB(databaseName: 'users');
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'usrName = ?',
      whereArgs: [usrName],
    );
    return result.isNotEmpty;
  }

  //Search Method
  Future<List<NoteModel>> searchNotes({
    required String databaseName,
    required String keyword,
  }) async {
    final Database db = await initDB(databaseName: databaseName);
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from notes where noteTitle LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  //CRUD -------------------------------------------------------------

  //Create Note
  Future<int> createNote({
    required String databaseName,
    required NoteModel note,
  }) async {
    final Database db = await initDB(databaseName: databaseName);
    return db.insert('notes', note.toMap());
  }

  //Get notes
  Future<List<NoteModel>> getNotes({required String databaseName}) async {
    final Database db = await initDB(databaseName: databaseName);
    List<Map<String, Object?>> result = await db.query('notes');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  //Delete Notes
  Future<int> deleteNote({
    required String databaseName,
    required int id,
  }) async {
    final Database db = await initDB(databaseName: databaseName);
    return db.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }

  //Update Notes
  Future<int> updateNote({
    required String databaseName,
    required String title,
    required String content,
    required int? noteId,
  }) async {
    final Database db = await initDB(databaseName: databaseName);
    return db.rawUpdate(
        'update notes set noteTitle = ?, noteContent = ? where noteId = ?',
        [title, content, noteId]);
  }
}
