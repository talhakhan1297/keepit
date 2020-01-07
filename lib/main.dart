import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep/searchTodoList.dart';
import 'package:keep/secondRoute.dart';

void main() {
  /*SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );*/
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var doc;

  void _addTodoItem(String title, String note, Timestamp timestamp) {
    if (title == null) {
      title = "";
    }
    if (note == null) {
      note = "";
    }
    if (title != "" || note != "") {
      setState(() {
        doc = {'title': title, 'note': note, 'timeStamp': timestamp};
        Firestore.instance.collection('todos').add(doc);
      });
    }
  }

  void _removeTodoItem(DocumentSnapshot document) {
    setState(() {
      Firestore.instance
          .collection('todos')
          .document(document.documentID)
          .delete();
    });
  }

  void _updateTodoItem(String title, String note, DocumentSnapshot document,
      Timestamp timestamp) {
    if (title == null) {
      title = "";
    }
    if (note == null) {
      note = "";
    }
    if (title != "" || note != "") {
      setState(() {
        doc = {'title': title, 'note': note, 'timeStamp': timestamp};
        Firestore.instance
            .collection('todos')
            .document(document.documentID)
            .updateData(doc);
      });
    } else {
      _removeTodoItem(document);
    }
  }

  void _editNote(DocumentSnapshot document, BuildContext context) async {
    String title = document['title'];
    String note = document['note'];

    if (title == null) {
      title = "";
    }
    if (note == null) {
      note = "";
    }

    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute(title, note, true)),
    );
    if (result != null) {
      _updateTodoItem(result[0], result[1], document, Timestamp.now());
    }
  }

  Widget _buildTodoItem(BuildContext context, AsyncSnapshot snapshot,
      DocumentSnapshot document, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 6.0,
      margin: EdgeInsets.fromLTRB(13.0, 16.0, 13.0, 0.0),
      color: Color(0xFF303030), //Tile Color
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () => _editNote(document, context),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Text(
              (document['title'] == null) ? '' : document['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Text(
              (document['note'] == null) ? '' : document['note'],
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
          ),
          trailing: IconButton(
            alignment: Alignment.center,
            icon: Icon(Icons.close),
            color: Colors.white38,
            onPressed: () => _removeTodoItem(snapshot.data.documents[index]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _floatingSearchBar() {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: StreamBuilder(
          stream: Firestore.instance.collection('todos').snapshots(),
          //stream: Firestore.instance.collection('todos').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("");
            return Container(
              color: Color(0xFF252525), // Main Container Color
              padding: const EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 8.0),
              child: FloatingSearchBar.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildTodoItem(
                      context, snapshot, snapshot.data.documents[index], index);
                },
                onChanged: (String value) {},
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: SearchTodoList(_editNote),
                  );
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Search your notes",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    _navigateToSecondRoute(BuildContext context) async {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute("", "", false)),
      );
      if (result != null) {
        _addTodoItem(result[0], result[1], Timestamp.now());
      }
    }

    Widget _textfield = Builder(
        builder: (context) => Container(
              decoration: BoxDecoration(color: Color(0xFF303030)),
              child: TextField(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _navigateToSecondRoute(context);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Take a note...',
                    hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                    contentPadding:
                        EdgeInsets.fromLTRB(25.0, 16.0, 16.0, 16.0)),
              ),
            ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF252525), // Main Background color
          accentColor: Colors.black,
        ),
        home: Column(
          children: [
            Expanded(
              child: _floatingSearchBar(),
            ),
            Card(
              child: _textfield,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              margin: EdgeInsets.all(0.0),
            ),
          ],
        ));
  }
}
