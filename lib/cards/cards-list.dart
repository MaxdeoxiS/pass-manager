import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  CardList({Key key}) : super(key: key);
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
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
