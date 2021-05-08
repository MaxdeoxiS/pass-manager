import 'package:flutter/material.dart';
import 'package:pass_manager/common/bottom-bar.dart';

class Layout extends StatelessWidget {
  final Widget body;
  Layout({required this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/password-create");
          },
          child: const Icon(Icons.add),
          tooltip: "Ajouter"),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(),
    );
  }
}
