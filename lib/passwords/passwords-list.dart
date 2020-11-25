import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/dao/password.dao.dart';
import 'package:pass_manager/utils/color.helper.dart';

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

  void _toggleFavorite(Password password) async {
    PasswordDao passwordDao = await dbHelper.getPasswordDao();
    Password newPassword = Password(password.name, password.login, password.value, password.url, password.comment, password.updated, password.color, !password.isFavorite, password.id);
    await passwordDao.updatePassword(newPassword);
    await _updateList();
  }

  void _onUpdate(Password password) async {
    PasswordDao passwordDao = await dbHelper.getPasswordDao();
    await passwordDao.updatePassword(password);
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
            title: Text('${items[index].name}', style: TextStyle(color: ColorHelper.getTextContrastedColor(items[index].color), fontWeight: FontWeight.w500)),
            subtitle: Text('${items[index].login}', style: TextStyle(color: ColorHelper.getTextContrastedColor(items[index].color))),
            trailing: IconButton(icon: Icon(items[index].isFavorite ? Icons.favorite : Icons.favorite_outline), onPressed: () => _toggleFavorite(items[index])),
            onTap: () {
              Navigator.pushNamed(context, '/password', arguments: PasswordViewArguments(items[index], this._deletePassword, this._onUpdate));
            },
            tileColor: items[index].color ?? Colors.white
          );
        },
      ) : Text("Aucun mot de passe enregistré"),
    );
  }
}

typedef void MyCallback(Password password);
class PasswordViewArguments {
  final Password password;
  final MyCallback onDelete;
  final MyCallback onUpdate;

  PasswordViewArguments(this.password, this.onDelete, this.onUpdate);
}