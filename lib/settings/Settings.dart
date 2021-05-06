import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          child: Row(
            children: [
              TextButton(onPressed: () => context.setLocale(Locale('fr', '')), child: Text("Français")),
              TextButton(onPressed: () => context.setLocale(Locale('en', '')), child: Text("Anglais")),
            ],
          )
        )
      )
    );
  }
}
