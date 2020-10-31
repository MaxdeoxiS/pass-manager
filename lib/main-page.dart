import 'package:flutter/material.dart';
import 'package:pass_manager/main-layout.dart';
import 'package:pass_manager/drawer.dart';

class MainPage extends StatelessWidget {
  final Widget body;
  final Text title;
  MainPage({this.body, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: MainLayout(body: body),
        drawer: MyDrawer());
  }
}
