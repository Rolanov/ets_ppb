import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/book.dart'; // Import the Tweet model

class BooksDatabase {
  static final BooksDatabase instance = BooksDatabase._init();
  static Database? _database;

  BooksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('books.db'); // Change database name to 'tweets.db'
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableBooks ( 
  ${BookFields.id} $idType, 
  ${BookFields.title} $textType,
  ${BookFields.description} $textType,
  ${BookFields.image} $textType,
  ${BookFields.time} $textType
  )
''');
  }

  Future<Book> create(Book book) async {
    final db = await instance.database;
    final id = await db.insert(tableBooks, book.toJson());
    return book.copy(id: id);
  }

  Future<Book> readBook(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBooks,
      columns: BookFields.values,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;
    final orderBy = '${BookFields.time} DESC'; // Order by time in descending order
    final result = await db.query(tableBooks, orderBy: orderBy);
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> update(Book book) async {
    final db = await instance.database;

    return db.update(
      tableBooks,
      book.toJson(),
      where: '${BookFields.id} = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableBooks,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
