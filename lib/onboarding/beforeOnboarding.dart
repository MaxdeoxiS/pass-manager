import 'package:flutter/material.dart';
import 'package:pass_manager/settings/Language.dart';

class BeforeOnboarding extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body: Language(fromOnboarding: true)
      );
  }

}
