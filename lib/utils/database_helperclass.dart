import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

//for dealing with files and folders
import 'package:path_provider/path_provider.dart';
import 'package:flutterap/models/notes.dart';

class Databasehelper {
  //lets declare singleton obj of this class
  //this database helper instance needs to be in form of singleton
  //singleton-this will have only one instance throigh out the app

  static Databasehelper _databasehelper; //Singleton Databasehelper
  //define singleton databse object

  static Database _database;

  //define all the colums of database allong with the table name

  String noteTable = 'note_Table';

  String colId = 'Id';

  String colTitle = 'title';

  String coldesc = 'desc';

  String colpriority = 'priority';

  String colDate = 'date';

  Databasehelper._createInstance();

//lets define factory constructor
  //the factory keyword will allow us to return something

  factory Databasehelper() {
    if (_databasehelper == null) {
      //calling a namedconstructor
      _databasehelper = Databasehelper._createInstance();
    } //null checker to make only oneinstance

    //here we will return the value 0f the singleton instance
    return _databasehelper;
  }

//getter for the database
  Future<Database> get database async {
    if (_database == null) {
      _database = await intializeDatabase();
    }
    return _database;
  }

//INITIALIZE OUR DATABASE FN

  Future<Database> intializeDatabase() async {
    //here we will first get the path for both android and ios where we can store
    //database

    Directory directory =
        await getApplicationDocumentsDirectory(); //pathproviderpackage
    //this fn return future obj so we have to use await

    //define path to our databse
    String path = directory.path + 'notes.db'; //naming it as notes.db

    //finally creating database at given path

    //open/create the database at give path

    var notesDatabase =
        await openDatabase(path, version: 5, onCreate: _createDb);

    return notesDatabase;
  }

//create a fn which will help us execcute a statement to create our database
  //sql statement

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT ,$coldesc TEXT ,$colpriority INTEGER ,$colDate TEXT)');
  }

//fetch operation : Get all note objects from database

  //we get list of map in return from db

  Future<List<Map<String, dynamic>>> getNotemaplist() async {
    Database db = await this.database; //referencing to database

    //performing query


        //db.rawQuery('SELECT *FROM $noteTable order by $colpriority ASC');
    var result =await db.query(noteTable,orderBy:'$colpriority ASC') ;//alternative this is a helper fn

    return result;
  }

//Insert operation :Inserting to database

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

//Update operation :updating to database

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  //delete operation :delete to database

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id');
    return result;
  }

  //GEt total number of Note objects in database

  Future<int> getCount(Note note) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //maptonote

  Future<List<Note>>  getNoteList() async {
    var noteMaplist =await getNotemaplist() ;
    int count = noteMaplist.length ;
    List<Note> notelist = List<Note>() ;

    for(int i = 0 ;i<= count-1 ; i++ ){

      notelist.add(Note.fromMapObject(noteMaplist[i])) ;


    }
    return notelist ;
  }
}
