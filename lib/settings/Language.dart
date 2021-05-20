import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Language extends StatelessWidget {
  void updateLocale(BuildContext context, String locale) {
    context.setLocale(Locale(locale, ''));
    Navigator.pop(context); // pop current page
    Navigator.pushNamed(context, "/settings/language"); // push it back in
  }

  Widget button(String locale, BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () => updateLocale(context, locale), child: Image.asset('assets/images/flag_$locale.png')),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: context.locale.toString() == locale ? 10 : 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    button('fr', context),
                    button('en', context),
                  ],
                ))));
  }
}
