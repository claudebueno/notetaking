import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notetaking/models/note.dart';
import 'package:notetaking/screens/note_detail.dart';
import 'package:notetaking/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Le Grenier à Notes',
          style: TextStyle(
              color: const Color(0xFFebf1f6), fontFamily: 'Quicksand'),
        ),
      ),
      backgroundColor: const Color(0xFFf48136),
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
        child: new Container(
          child: getNoteListView(),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            onPressed: () {
              debugPrint('FAB cliqué pour ajout de note');
              navigateToDetail(Note('', '', 2), 'Ajouter une Note');
            },
            label: Text(
              'Ajouter une Note',
              style: TextStyle(
                  fontFamily: 'Quicksand', color: const Color(0xFFd05855)),
            ),
            icon: Icon(
              Icons.add,
              color: const Color(0xFFd05855),
            ),
            backgroundColor: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          color: Colors.transparent,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: const Color(0xFFFFFFFF),
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                this.noteList[position].date,
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: const Color(0xFFFFFFFF),
                    fontSize: 14.0),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: const Color(0xFFffddbc),
                ),
                onTap: () {
                  _delete(context, noteList[position]);
                },
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetail(this.noteList[position], 'Modifier la Note');
              },
            ),
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.white;
        break;
      case 2:
        return Colors.white;
        break;

      default:
        return Colors.white;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(
          Icons.star,
          color: Colors.red,
        );

        break;
      case 2:
        return Icon(
          Icons.keyboard_arrow_right,
          color: const Color(0xFFd05855),
        );
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'La Note a été supprimée avec succès');
      debugPrint(note.description);
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          debugPrint(noteList.length.toString());
        });
      });
    });
  }
}
