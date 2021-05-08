import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  NoteList({Key? key}) : super(key: key);
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Prochainement'),
    );
  }
}
