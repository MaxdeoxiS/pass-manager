import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/password-generation.dart';
import 'package:pass_manager/passwords/passwords-list.dart';
import 'package:pass_manager/utils/hex-color.dart';
import 'package:url_launcher/url_launcher.dart';

import 'entity/password.entity.dart';

const DEFAULT_COLOR = Colors.red;

class PasswordView extends StatefulWidget {
  final MyCallback onDelete;
  final MyCallback onUpdate;
  final Password password;

  PasswordView({Key key, this.onDelete, this.onUpdate, this.password}) : super(key: key);
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  Password password;
  bool _isEditing = false;
  bool _hidePassword = true;
  final _loginController = TextEditingController();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    password = widget.password;
    _loginController.text = password.login;
    _urlController.text = password.url;
    _nameController.text = password.name;
    _passwordController.text = password.value;
    super.initState();
  }

  _toggleFavorite() {
    setState(() {
      password.isFavorite = !password.isFavorite;
    });
  }

  _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  _onBackPressed() {
    widget.onUpdate(password);
    Navigator.pop(context);
  }

  _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _handlePasswordGeneration() async {
    String rep = await _showPasswordGenerationDialog(this.context, this.password.color);
    setState(() {
      _passwordController.text = rep;
    });
  }

  void _handlePasswordDeletion() async {
    bool delete = await _showPasswordDeletionDialog(this.context);
    if (delete) {
      widget.onDelete(password);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // other dispose methods
    _loginController.dispose();
    _urlController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: this.password.color ?? DEFAULT_COLOR,
                  height: MediaQuery.of(context).size.height * .2,
                  padding: EdgeInsets.only(top: 24, bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back), onPressed: () => _onBackPressed(), color: Colors.white),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _handlePasswordDeletion(),
                              color: Colors.white),
                        ],
                      ),
                      Text(_nameController.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Label('Identifiant'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          (this._isEditing
                              ? Expanded(
                                  child: TextField(
                                  controller: _loginController,
                                  decoration:
                                      InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
                                ))
                              : Text(this.password.login, style: TextStyle(fontSize: 17))),
                          IconButton(icon: Icon(Icons.copy), onPressed: () => {})
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Label('Mot de passe'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                              _hidePassword
                                  ? _passwordController.text.replaceAll(new RegExp(r'.'), '*')
                                  : _passwordController.text,
                              style: TextStyle(fontSize: 17)),
                          Row(
                            children: [
                              _isEditing
                                  ? (IconButton(
                                      icon: Icon(Icons.refresh), onPressed: () => _handlePasswordGeneration()))
                                  : Container(),
                              IconButton(
                                  icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => _toggleHidePassword()),
                              IconButton(icon: Icon(Icons.copy), onPressed: () => {})
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Label('URL'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          (this._isEditing
                              ? Expanded(
                                  child: TextField(
                                  controller: _urlController,
                                  decoration:
                                      InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
                                ))
                              : Text(_urlController.text, style: TextStyle(fontSize: 16))),
                          Row(
                            children: [
                              IconButton(icon: Icon(Icons.open_in_browser), onPressed: () => _openUrl(password.url)),
                              IconButton(icon: Icon(Icons.copy), onPressed: () => {})
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Label('Commentaire'),
                  Text(this.password.comment),
                  Label('Dernière mise à jour du mot de passe'),
                  Text(this.password.updated.toLocal().toString()),
                  IconButton(
                      icon: Icon(password.isFavorite ? Icons.favorite : Icons.favorite_outline),
                      onPressed: () => _toggleFavorite(),
                      color: password.color),
                ],
              )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _isEditing
                  ? [
                      BottomButton('Annuler', password.color, _toggleEdit),
                      BottomButton('Valider', password.color, _toggleEdit)
                    ]
                  : [BottomButton('Modifier', password.color, _toggleEdit)],
            ),
          ),
        ],
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;

  Label(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(color: Colors.blueGrey, fontSize: 14));
  }
}

class BottomButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function onClick;

  BottomButton(this.label, this.color, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: FlatButton(
          color: this.color,
          onPressed: this.onClick,
          child: Text(this.label),
          height: 50,
        ),
      ),
    ]);
  }
}

Future<String> _showPasswordGenerationDialog(BuildContext context, Color color) async {
  return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PasswordGeneration(color);
      });
}

Future<bool> _showPasswordDeletionDialog(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AlertDialog"),
          content: Text("Would you like to continue learning how to use Flutter alerts?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context, false)
            ),
            FlatButton(
              child: Text("Continue"),
              onPressed: () => Navigator.pop(context, true)
            )
          ],
        );
      });
}
