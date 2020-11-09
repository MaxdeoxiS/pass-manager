import 'package:flutter/material.dart';

import '../database.helper.dart';
import 'models/password.dart';

class PasswordList extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("PasswordList"),
    );
  }
}