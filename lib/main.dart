import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Page, Key;
import 'package:pass_manager/passwords/views/password-creation.dart';
import 'package:pass_manager/passwords/views/password-view.dart';
import 'package:pass_manager/passwords/views/passwords-list.dart';
import 'package:flutter/services.dart';
import 'package:pass_manager/settings/Settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import 'cards/cards-list.dart';
import 'common/page.dart';
import 'notes/notes-list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final storage = new FlutterSecureStorage();

  String? value = await storage.read(key: 'privateKey');

  if (null == value || value.length != 32) {
    var uuid = Uuid();
    await storage.write(key: 'privateKey', value: uuid.v4().substring(0, 32));
  }

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', ''), Locale('fr', '')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', ''),
        child: MainApp()
    ),
  );
}

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
        page = buildPageRoute(Page(body: PasswordList(), title: Text('passwords.title'.tr())));
        break;
      case "/notes":
        page = buildPageRoute(Page(body: NoteList(), title: Text('notes.title'.tr())));
        break;
      case "/cards":
        page = buildPageRoute(Page(body: CardList(), title: Text('cards.title'.tr())));
        break;
      case "/password-create":
        page = buildPageRoute(PasswordCreation());
        break;
      case "/password":
        PasswordViewArguments args = settings.arguments as PasswordViewArguments;
        page = buildPageRoute(PasswordView(password: args.password, onDelete: args.onDelete, onUpdate: args.onUpdate));
        break;
      case "/settings":
      default:
        page = buildPageRoute(Page(body: Settings(), title: Text('settings.title'.tr())));
        break;
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Pass manager',
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
