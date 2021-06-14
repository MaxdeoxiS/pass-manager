import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/utils/Filter.dart';
import 'package:pass_manager/passwords/utils/PasswordManager.dart';
import 'package:pass_manager/passwords/utils/filter_provider.dart';
import 'package:pass_manager/utils/color.helper.dart';

import '../entity/password.entity.dart';
import '../utils/filter_bloc.dart';

class PasswordList extends StatefulWidget {
  PasswordList({Key? key}) : super(key: key);
  _PasswordListState createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  final _passwordManager = PasswordManager.instance;
  List<Password> items = [];
  bool filterOnFavorites = false;

  _updateList() async {
    List<Password> passwords = await _passwordManager.getPasswords();
    setState(() {
      items = passwords;
    });
  }

  void _deletePassword(int id) async {
    await _passwordManager.deletePassword(id);
    await _updateList();
  }

  void _toggleFavorite(Password password) async {
    _passwordManager.toggleFavorite(password);
    await _updateList();
  }

  void _onUpdate(Password password) async {
    await _passwordManager.updatePassword(password);
    await _updateList();
  }

  @override
  void initState() {
    _updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: blocFilter.getFilter,
        initialData: FilterProvider().filter,
        builder: (context, snapshot) {
          Filter filter = snapshot.data as Filter;
          List<Password> _passwords = items.where((p) => filter.favorites ? p.isFavorite : true).toList();
          if (filter.categories.length > 0) {
            _passwords = _passwords.where((pass) => filter.categories.contains(pass.category?.name)).toList();
          }
          if (null != filter.search) {
            _passwords = _passwords
                .where((pass) => pass.name.contains(filter.search!) || pass.login.contains(filter.search!))
                .toList();
          }
          return Scaffold(
            body: _passwords.length > 0
                ? ListView.builder(
                    itemCount: _passwords.length,
                    itemBuilder: (context, index) {
                      Password password = _passwords[index];
                      print(password.category?.icon);
                      return ListTile(
                          leading: Icon(IconData(password.category?.icon ?? 0, fontFamily: "MaterialIcons"), size: 35),
                          title: Text('${password.name}',
                              style: TextStyle(
                                  color: ColorHelper.getTextContrastedColor(password.color),
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text('${password.login}',
                              style: TextStyle(color: ColorHelper.getTextContrastedColor(password.color))),
                          trailing: IconButton(
                              icon: Icon(password.isFavorite ? Icons.favorite : Icons.favorite_outline),
                              onPressed: () => _toggleFavorite(password)),
                          onTap: () {
                            Navigator.pushNamed(context, '/password',
                                arguments: PasswordViewArguments(items[index], this._deletePassword, this._onUpdate));
                          },
                          tileColor: password.color);
                    },
                  )
                : Padding(padding: EdgeInsets.only(bottom: 64.0), child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset('assets/images/no-password.png'),
                      Text("Oups", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text("Aucun mot de passe enregistré", style: TextStyle(fontSize: 15)))
                    ]),
                  )),
          );
        });
  }
}

typedef void UpdateCallback(Password password);
typedef void DeleteCallback(int id);

class PasswordViewArguments {
  final Password password;
  final DeleteCallback onDelete;
  final UpdateCallback onUpdate;

  PasswordViewArguments(this.password, this.onDelete, this.onUpdate);
}
