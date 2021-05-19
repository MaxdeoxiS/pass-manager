import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Language extends StatelessWidget {
  void updateLocale(BuildContext context, String locale) {
    context.setLocale(Locale(locale, ''));
    Navigator.pop(context); // pop current page
    Navigator.pushNamed(context, "/settings/language"); // push it back in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: 100,
                child: Row(
                  children: [
                    TextButton(onPressed: () => updateLocale(context, 'fr'), child: Text('settings.french'.tr())),
                    TextButton(onPressed: () => updateLocale(context, 'en'), child: Text('settings.english'.tr())),
                  ],
                ))));
  }
}
