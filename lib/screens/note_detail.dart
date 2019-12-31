import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaking/models/note.dart';
import 'package:notetaking/utils/database_helper.dart';

// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {
  String appBarTitle;
  Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['Haute', 'Basse'];
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle textStyle = new TextStyle(
        fontFamily: 'Quicksand',
        color: const Color(0xFFFFFFFF),
        fontSize: 18.0);

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        //code when user press Back button AppBar
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf48136),
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            appBarTitle,
            style: TextStyle(
                color: const Color(0xFFebf1f6), fontFamily: 'Quicksand'),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                //code when user press Back button AppBar
                moveToLastScreen();
              }),
        ),
        body: new Container(
          padding: const EdgeInsets.all(12.0),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [const Color(0xFFf48136), const Color(0xFFdb1c0a)],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: ListView(
            children: <Widget>[
              // First Element
              ListTile(
                title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xFFf48136)),
                        ),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint(
                            'Utilisateur a selectionné $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    }),
              ),
              // Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Le titre a changé');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Titre',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              // Troisième Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('La decription a changé');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              // Quatrième Elément
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: const Color(0xFFFFFFFF),
                        textColor: const Color(0xFFd05855),
                        child: Text(
                          'Enregistrer',
                          textScaleFactor: 1.3,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: const Color(0xFFd05855),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Le bouton Enregistrer a été cliqué');
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 20.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: const Color(0xFFFFFFFF),
                        child: Text(
                          'Annuler',
                          textScaleFactor: 1.3,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: const Color(0xFFd05855),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Le bouton Annuler a été cliqué');
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

// Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Haute':
        note.priority = 1;
        break;
      case 'Basse':
        note.priority = 2;
        break;
    }
  }

// Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'La note a été actualisée avec succès');
    } else {
      // Failure
      _showAlertDialog('Status', 'La note n\'a pas été mise à jour');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
