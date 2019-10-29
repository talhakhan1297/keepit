import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  final String title;
  final String note;
  final bool edit;
  String titleBuffer;
  String noteBuffer;
  List<String> _note = [];

  SecondRoute(this.title, this.note, this.edit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF252525),
        title: Text(""),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: TextFormField(
              initialValue: (edit == true) ? title : "",
              onChanged: (text) {
                titleBuffer = text;
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Colors.white38,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                    color: Colors.white38,
                    fontSize: 24.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
                contentPadding: EdgeInsets.fromLTRB(25.0, 16.0, 16.0, 16.0),
              ),
            ),
          ),
          Container(
            child: TextFormField(
              initialValue: (edit == true) ? note : "",
              maxLines: null,
              onChanged: (text) {
                noteBuffer = text;
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Colors.white38,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 16.0),
                contentPadding: EdgeInsets.fromLTRB(25.0, 16.0, 16.0, 16.0),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(Icons.check, color: Colors.black),
            onPressed: () {
              if (titleBuffer == null) titleBuffer = title;
              if (noteBuffer == null) noteBuffer = note;
              _note.add(titleBuffer);
              _note.add(noteBuffer);
              Navigator.pop(context, _note);
            },
          )
        ],
      ),
    );
  }
}
