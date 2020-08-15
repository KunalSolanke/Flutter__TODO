import 'package:flutter/material.dart';
import 'dart:async';

//import 'package:flutter/material.dart';
//import 'package:flutterap/screens/note_detail.dart';
import 'package:flutterap/utils/database_helperclass.dart';

//import 'package:sqflite/sqflite.dart';
import 'package:flutterap/models/notes.dart';

//import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Notedetail extends StatefulWidget {
  final String appBartitle;
  final Note note;

  Notedetail(this.note, this.appBartitle); //constructor
  @override
  State<StatefulWidget> createState() {
    return _notedetailState(this.note, this.appBartitle);
  }
}

class _notedetailState extends State<Notedetail> {
  static var _priorities = ['High', 'Low'];

  TextEditingController titlecont = TextEditingController();

  TextEditingController desccont = TextEditingController();

  String appBartitle;
  Note note;

  Databasehelper databasehelper = Databasehelper();

  _notedetailState(this.note, this.appBartitle); //constructor

  @override
  Widget build(BuildContext context) {
    titlecont.text = note.title;
    desccont.text = note.desc;
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return WillPopScope(
        onWillPop: () {
          moveToLastscreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBartitle),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastscreen();
                },
              ),
            ),
            body: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                        title: DropdownButton(
                            items: _priorities.map((String dropitems) {
                              return DropdownMenuItem<String>(
                                  value: dropitems, child: Text(dropitems));
                            }).toList(),
                            style: textStyle,
                            onChanged: (valByuser) {
                              setState(() {
                                updatePriorityAsInt(valByuser);
                                debugPrint("Val by user is $valByuser");
                              });
                            },
                            value: getPriorityAsString(note.priority))),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: titlecont,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Title",
                            hintStyle: textStyle,
                            hintText: "note name here",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          updateTite();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: desccont,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Description",
                            hintStyle: textStyle,
                            hintText: "note here",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          updatedesc();
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text(
                                  "Save",
                                  textScaleFactor: 1.5,
                                ),
                                elevation: 6.0,
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  debugPrint("Save clicked");
                                  _save();
                                },
                              ),
                            ),
                            Container(
                              width: 5.0,
                            ),
                            Expanded(
                              child: RaisedButton(
                                child: Text(
                                  "Delete",
                                  textScaleFactor: 1.5,
                                ),
                                elevation: 6.0,
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  debugPrint("Delete clicked");
                                  _delete();
                                },
                              ),
                            )
                          ],
                        ))
                  ],
                ))));
  }

  void moveToLastscreen() {
    Navigator.pop(context, true);
  }

  //covert string prior to integer to save in database

  void updatePriorityAsInt(value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //covert int prior to string to save in database

  String getPriorityAsString(value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;

//      default:
//        priority = _priorities[1];
//        break;
    }
    return priority;
  }

  //helper fn for updating title and the desc

  void updateTite() {
    note.title = titlecont.text;
  }

  void updatedesc() {
    note.desc = desccont.text;
  }

  //helper class for the the buttons

  void _save() async {
    moveToLastscreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      //update
      result = await databasehelper.updateNote(note);
    } else {
      result = await databasehelper.insertNote(note);
    }

    if (result != 0) {
      //success
      _showalertdialog("Status", "Note Saved Succesfuly");
    } else {
      _showalertdialog("Status", "Problem saving Note");
    }
  }

  void _showalertdialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

//delete

  void _delete() async {
    moveToLastscreen();
    if (note.id == null) {
      _showalertdialog('Status', "No note was deleted ");
      return;
    }
    int result;
    result = await databasehelper.deleteNote(note.id);

    if (result != 0) {
      //success
      _showalertdialog("Status", "Note Deleted Succesfuly");
    } else {
      _showalertdialog("Status", "Problem deleting Note");
    }
  }
}
