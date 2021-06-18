import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Page, Key;
import 'package:pass_manager/onboarding/Onboarding.dart';
import 'package:pass_manager/onboarding/beforeOnboarding.dart';
import 'package:pass_manager/passwords/views/password-creation.dart';
import 'package:pass_manager/passwords/views/password-view.dart';
import 'package:pass_manager/passwords/views/passwords-list.dart';
import 'package:flutter/services.dart';
import 'package:pass_manager/settings/About.dart';
import 'package:pass_manager/settings/Import.dart';
import 'package:pass_manager/settings/Settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'cards/cards-list.dart';
import 'common/page.dart';
import 'notes/notes-list.dart';
import 'settings/Language.dart';
import 'settings/Export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final storage = new FlutterSecureStorage();

  String? value = await storage.read(key: 'privateKey');

  if (null == value || value.length != 32) {
    var uuid = Uuid();
    await storage.write(key: 'privateKey', value: uuid.v4().substring(0, 32));
  }
  final prefs = await SharedPreferences.getInstance();
  final bool firstLaunch = true;// prefs.getBool('firstLaunch') ?? true;

  String initialRoute = firstLaunch ? '/onboarding/lang' : '/';

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', ''), Locale('fr', '')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', ''),
        child: MainApp(initialRoute: initialRoute)
    ),
  );
}

class MainApp extends StatelessWidget {
  String initialRoute;

  MainApp({required this.initialRoute});

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
      case "/onboarding/lang":
        page = buildPageRoute(BeforeOnboarding());
        break;
      case "/onboarding/starter":
        page = buildPageRoute(Onboarding());
        break;
      case "/":
      case "/passwords":
        page = buildPageRoute(Page(body: PasswordList(), title: Text('passwords.title'.tr()), routeName: "passwords"));
        break;
      case "/notes":
        page = buildPageRoute(Page(body: NoteList(), title: Text('notes.title'.tr()), routeName: "notes"));
        break;
      case "/cards":
        page = buildPageRoute(Page(body: CardList(), title: Text('cards.title'.tr()), routeName: "cards"));
        break;
      case "/password-create":
        page = buildPageRoute(PasswordCreation());
        break;
      case "/password":
        PasswordViewArguments args = settings.arguments as PasswordViewArguments;
        page = buildPageRoute(PasswordView(password: args.password, onDelete: args.onDelete, onUpdate: args.onUpdate));
        break;
      case "/settings/language":
        page = buildPageRoute(Page(body: Language(fromOnboarding: false), title: Text('settings.language'.tr()), routeName: "/language"));
        break;
      case "/settings/import":
        page = buildPageRoute(Page(body: Import(), title: Text('settings.import'.tr()), routeName: "/language"));
        break;
      case "/settings/export":
        page = buildPageRoute(Page(body: Export(), title: Text('settings.export'.tr()), routeName: "/language"));
        break;
      case "/settings/about":
        page = buildPageRoute(Page(body: About(), title: Text('settings.about'.tr()), routeName: "/about"));
        break;
      case "/settings":
      default:
        page = buildPageRoute(Page(body: Settings(), title: Text('settings.title'.tr()), routeName: "settings"));
        break;
    }
    return page;
  }

  Map<int, Color> color =
  {
    50:Color.fromRGBO(136, 1, 0, .50),
    100:Color.fromRGBO(136, 1, 0, .60),
    200:Color.fromRGBO(136, 1, 0, .65),
    300:Color.fromRGBO(136, 1, 0, .70),
    400:Color.fromRGBO(136, 1, 0, .75),
    500:Color.fromRGBO(136, 1, 0, .80),
    600:Color.fromRGBO(136, 1, 0, .85),
    700:Color.fromRGBO(136, 1, 0, .90),
    800:Color.fromRGBO(136, 1, 0, .95),
    900:Color.fromRGBO(136, 1, 0, 1),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Pass manager',
      theme: ThemeData(
        primaryColor: Color(0xFF880100),
        primarySwatch: MaterialColor(0xFF880100, color),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
