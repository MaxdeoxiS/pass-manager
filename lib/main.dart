import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/password-creation.dart';
import 'package:pass_manager/passwords/passwords-list.dart';

import 'main-page.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  PageRouteBuilder buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return child;
      },
    );
  }
  Route onGenerateRoute(RouteSettings settings) {
    Route page;
    switch (settings.name) {
      case "/":
        page = buildPageRoute(MainPage(body: PasswordList(), title: Text("Home")));
        break;
      case "/passwords":
        page = buildPageRoute(MainPage(body: PasswordList(), title: Text("Home")));
        break;
      case "/password-create":
        page = buildPageRoute(PasswordCreation());
        break;
    }
    return page;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gestionnaire mdp',
        theme: ThemeData(
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
    );
  }
}