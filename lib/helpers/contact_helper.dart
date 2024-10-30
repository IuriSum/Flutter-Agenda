import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  // TODO: Study factory and internal Methods, Singleton
  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database _db;

  Future<Database> get db async{
    if(_db.isOpen){
      return _db;
    }

    _db = await initDb();
    return _db;

  }

  Future<Database> initDb()async{
    final String databasesPath = await getDatabasesPath();
    final String path = "${databasesPath}contacts.db";

    return openDatabase(path, version: 1, onCreate: (Database db, int newerVersion)async{
      String query = '''
        CREATE TABLE $contactTable(
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
        )
      ''';
      await db.execute(
        query
      );
    });
  }

  Future<Contact> saveContact(Contact contact)async{
    Database database = await db;
    contact.id = await database.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id)async{
    Database database = await db;
    List<Map<String,dynamic>> result = await database.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]
    );

    if(result.isNotEmpty){
      return Contact.fromMap(result.first);
    }
    
    return null;
  }

  Future<Contact> updateContact(Contact contact)async{
    Database database = await db;
    await database.update(
      contactTable, 
      contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id]
    );
    return contact;
  }

  Future<int> deleteContact(int id)async{
    Database database = await db;
    return await database.delete(
      contactTable,
      where: "$idColumn = ?",
      whereArgs: [id]
    );
  }

  Future<List<Contact>> getAllContacts()async{
    Database database = await db;
    List <Map<String, dynamic>> contactQuery = await database.rawQuery('SELECT*FROM $contactTable');
    return List.generate(contactQuery.length, (index) => Contact.fromMap(contactQuery[index]));
  }

  Future <int?> getNumber() async {
    Database database = await db;
    return Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future<void> close()async{
    Database database = await db;
    database.close();
  }

}

class Contact {
  late int? id;
  late String name;
  late String email;
  late String phone;
  late String img;

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString(){
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}