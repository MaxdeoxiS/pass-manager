import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/utils/PasswordManager.dart';
import 'package:pass_manager/passwords/utils/favorites_provider.dart';
import 'package:pass_manager/utils/color.helper.dart';

import '../entity/password.entity.dart';
import '../utils/favorites_block.dart';

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
      stream: bloc.getFavorites,
      initialData: FavoritesProvider().favorites,
      builder: (context, snapshot) {
        bool filterFav = snapshot.data as bool;
        List<Password> _passwords = items.where((p) => filterFav ? p.isFavorite : true).toList();
        return Scaffold(
          body: _passwords.length > 0 ? ListView.builder(
            itemCount: _passwords.length,
            itemBuilder: (context, index) {
              Password password = _passwords[index];
              return ListTile(
                  title: Text('${password.name}', style: TextStyle(color: ColorHelper.getTextContrastedColor(password.color), fontWeight: FontWeight.w500)),
                  subtitle: Text('${password.login}', style: TextStyle(color: ColorHelper.getTextContrastedColor(password.color))),
                  trailing: IconButton(icon: Icon(password.isFavorite ? Icons.favorite : Icons.favorite_outline), onPressed: () => _toggleFavorite(password)),
                  onTap: () {
                    Navigator.pushNamed(context, '/password', arguments: PasswordViewArguments(items[index], this._deletePassword, this._onUpdate));
                  },
                  tileColor: password.color
              );
            },
          ) : Text("Aucun mot de passe enregistré"),
        );
      }
    );
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