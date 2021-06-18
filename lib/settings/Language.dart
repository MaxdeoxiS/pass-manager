import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Language extends StatelessWidget {
  bool fromOnboarding;
  Language({required this.fromOnboarding});

  void updateLocale(BuildContext context, String locale) {
    context.setLocale(Locale(locale, ''));
    if (fromOnboarding) {
      return;
    }
    Navigator.pop(context); // pop current page
    Navigator.pushNamed(context, "/settings/language"); // push it back in
  }

  Widget button(String locale, BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () => updateLocale(context, locale),
          child: Image.asset('assets/images/flag_$locale.png', height: 100, width: 100)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: context.locale.toString() == locale ? 4 : 0),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
    );
  }

  onOnboardingValidate(BuildContext context) {
    print("coucou");
    Navigator.of(context).pushReplacementNamed("/onboarding/starter");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(8.0), child: button('fr', context)),
                    Padding(padding: EdgeInsets.all(8.0), child: button('en', context)),
                    fromOnboarding
                        ? Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: TextButton(onPressed: () => onOnboardingValidate(context), child: Text("global.validate").tr()))
                        : Text("")
                  ],
                ))));
  }
}
