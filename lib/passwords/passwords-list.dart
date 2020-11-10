import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/dao/password.dao.dart';

import '../database.helper.dart';
import 'entity/password.entity.dart';

class PasswordList extends StatefulWidget {
  PasswordList({Key key}) : super(key: key);
  _PasswordListState createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  final dbHelper = DatabaseHelper.instance;
  List<Password> items = [];

  _updateList() {
    dbHelper.getPasswordDao().then((passwordDao){
      passwordDao.findAllPasswords().then((passwords){
        setState(() {
          items = passwords;
        });
      });
    });
  }

  void _deletePassword(Password password) async {
    PasswordDao passwordDao = await dbHelper.getPasswordDao();
    await passwordDao.deletePassword(password);
    await _updateList();
  }

  @override
  void initState() {
    _updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.length > 0 ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index].name}'),
            subtitle: Text('${items[index].login}'),
            leading: IconButton(icon: Icon(Icons.circle), onPressed: () {}),
            trailing: IconButton(icon: Icon(Icons.favorite_outline), onPressed: () {}),
            onTap: () {
              Navigator.pushNamed(context, '/password', arguments: ScreenArguments(items[index], this._deletePassword));
            }
          );
        },
      ) : Text("Aucun mot de passe enregistré"),
    );
  }
}

typedef void MyCallback(Password password);
class ScreenArguments {
  final Password password;
  final MyCallback onDelete;

  ScreenArguments(this.password, this.onDelete);
}