import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/passwords-list.dart';

import '../database.helper.dart';
import 'dao/password.dao.dart';
import 'entity/password.entity.dart';

class PasswordView extends StatelessWidget {
  final Password password;
  final MyCallback onDelete;

  PasswordView({this.password, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Modifier un mot de passe'),
    ),
    body: Column(
      children: [
        Text(this.password.name),
        Text(this.password.login),
        Text(this.password.value),
        Text(this.password.url),
        Text(this.password.comment),
        Text(this.password.updated.toString()),
        IconButton(icon: Icon(Icons.delete), onPressed: () { this.onDelete(password); Navigator.pop(context); })
      ],
    ),
    );
  }
}