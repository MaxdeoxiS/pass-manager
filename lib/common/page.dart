import 'package:flutter/material.dart';
import 'package:pass_manager/common/layout.dart';
import 'package:pass_manager/common/drawer.dart';

class Page extends StatelessWidget {
  final Widget body;
  final Text title;
  final String routeName;

  Page({required this.body, required this.title, required this.routeName});

  Widget? buildDrawer() {
    if (this.routeName.contains('/')) {
      return null;
    }
    return MyDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: Layout(body: body, page: routeName),
        drawer: buildDrawer());
  }
}
