import 'package:flutter/material.dart';
import 'package:pass_manager/bottom-bar.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  MainLayout({this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Floating action button pressed');
            Navigator.pushNamed(context, "/password-create");
          },
          child: const Icon(Icons.add),
          tooltip: "Ajouter"),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(),
    );
  }
}