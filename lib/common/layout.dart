import 'package:flutter/material.dart';
import 'package:pass_manager/common/bottom-bar.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final String page;

  Layout({required this.body, required this.page});

  Widget? buildFAB(context) {
    switch (page) {
      case 'passwords':
        return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/password-create");
            },
            child: const Icon(Icons.add),
            tooltip: "Ajouter");
      case '':
      default:
        return null;
    }
  }

  buildBottomNavigation() {
    switch (page) {
      case 'passwords':
        return BottomBar();
      case '':
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: this.buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: this.buildBottomNavigation(),
    );
  }
}
