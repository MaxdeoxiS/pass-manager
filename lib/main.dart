import 'package:flutter/material.dart' hide Page;
import 'package:pass_manager/passwords/password-creation.dart';
import 'package:pass_manager/passwords/password-view.dart';
import 'package:pass_manager/passwords/passwords-list.dart';

import 'cards/cards-list.dart';
import 'common/page.dart';
import 'notes/notes-list.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  /// Build page route with provided [page] content
  PageRouteBuilder buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return child;
      },
    );
  }

  /// App routing
  /// Takes [settings] parameter to pass arguments to each page
  Route onGenerateRoute(RouteSettings settings) {
    Route page;
    switch (settings.name) {
      case "/":
      case "/passwords":
        page = buildPageRoute(Page(body: PasswordList(), title: Text("Mots de passe")));
        break;
      case "/notes":
        page = buildPageRoute(Page(body: NoteList(), title: Text("Notes")));
        break;
      case "/cards":
        page = buildPageRoute(Page(body: CardList(), title: Text("Cartes")));
        break;
      case "/password-create":
        page = buildPageRoute(PasswordCreation());
        break;
      case "/password":
        PasswordViewArguments args = settings.arguments;
        page = buildPageRoute(PasswordView(password: args.password, onDelete: args.onDelete, onUpdate: args.onUpdate));
        break;
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pass manager',
        theme: ThemeData(
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
    );
  }
}