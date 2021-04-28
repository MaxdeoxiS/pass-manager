import 'package:flutter/material.dart';
import 'package:pass_manager/common/layout.dart';
import 'package:pass_manager/common/drawer.dart';

class Page extends StatelessWidget {
  final Widget body;
  final Text title;
  Page({this.body, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: Layout(body: body),
        drawer: MyDrawer());
  }
}
