import 'package:flutter/material.dart';
import 'package:flutterap/screens/note_detail.dart';
import 'package:flutterap/utils/database_helperclass.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutterap/models/notes.dart';
//import 'package:path_provider/path_provider.dart';

class Notelist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _notelistState();
  }
}

class _notelistState extends State<Notelist> {
  Databasehelper databasehelper =
      Databasehelper(); //instance of singleton dattabase
  List<Note> noteList;

  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null) {
      List<Note> noteList = List<Note>() ;
      updateListvview() ;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getnotelist(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("Fab clicked ");
            // ignore: missing_return
            navtoDetail(Note('','',2),"Add Note");
          },
          tooltip: "Add Note",
          child: Icon(Icons.add)),
    );
  }

  ListView getnotelist() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: getPrioritycolor(this.noteList[position].priority),
                  child: getPriorityIcon(this.noteList[position].priority),
                ),
                title: Text(this.noteList[position].title, style: textStyle),
                subtitle: Text(this.noteList[position].date),
                trailing:GestureDetector(
                child:Icon(Icons.delete, color: Colors.grey),
                onTap: (){
                  _delete(context, noteList[position]) ;

                },),

                onTap: () {
                  debugPrint("Hi");
                  navtoDetail(this.noteList[position],"Edit Note");
                },
              ));
        });
  }

  //helper fn

  //Return priority color
  Color getPrioritycolor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  //return icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }


  //delete note

  void _delete(BuildContext context, Note note) async {
    int result = await databasehelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackbar(context, "Note is Deleted");
      updateListvview() ;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void navtoDetail(Note note ,String title) async {
    bool result =await Navigator.push(context, MaterialPageRoute(builder: (context) {
      // ignore: missing_return
      return Notedetail(note,title);
    }));
    if (result == true) {
      updateListvview() ;
    }
  }

  //notelist

  void updateListvview(){
    final Future<Database> dbFuture = databasehelper.intializeDatabase() ;

    dbFuture.then((database){
      setState(() {

        Future<List<Note>> noteListFuture =databasehelper.getNoteList() ;
        noteListFuture.then((database){
        this.noteList =noteList ;
        if(noteList != null ){
          this.count =noteList.length ;
        }
        else{
          this.count= 0 ;
        }}) ;
      });
    }) ;
    //
  }
}
