class Note {
  int _id;

  String _title;

  String _date;

  String _desc;

  int _priority;

  //constructor

  Note(this._title, this._date, this._priority, [this._desc]);

  //this._desc is made optiional
//one more constructor that will also accept id as a parameter
  Note.withId(this._id, this._title, this._date, this._priority, [this._desc]);

  //this is a named constructor
//we cannot have to unnamed constructor in same class

  //now getters
  int get id => _id;

  String get title => _title;

  String get desc => _desc;

  int get priority => _priority;

  String get date => _date;

  //now setter

//id do not need setters as id in datab will be generated automatically

  set title(String newTitle) {
    //validation layer
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set desc(String newdesc) {
    //validation layer
    if (newdesc.length <= 500) {
      this._desc = newdesc;
    }
  }

  set date(String newdate) {
    //validation layer

    this._date = newdate;
  }

  set priority(int newPriority) {
    //validation layer
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //FN FOR CONVERTING NOTE OBJ INTO MAP OBJ

//map<key,value> the key of the dict is string in all the case while value is int and string so dynamic
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); //instancre of empy map obj

    //for id we have to first check if id is null or not depending on what the func is getting used
    //for either updating or inserting

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['desc'] = _desc;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //fn which will help to extract note obj from map obj
//reverse of above

//lets add named construct that will take map as a parameter

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._priority = map['priority'];
    this._desc = map['desc'];
    this._date = map['date'];
    this._title = map['title'];
  }
}

//underscore to make the variables private to the our own lib
