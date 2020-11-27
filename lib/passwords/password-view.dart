import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/passwords-list.dart';
import 'package:pass_manager/utils/hex-color.dart';
import 'package:url_launcher/url_launcher.dart';

import 'entity/password.entity.dart';

const DEFAULT_COLOR = Colors.red;

class PasswordView extends StatefulWidget {
  final MyCallback onDelete;
  final MyCallback onUpdate;
  final Password password;

  PasswordView({ Key key, this.onDelete, this.onUpdate, this.password }) : super(key: key);
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  Password password;
  bool _isEditing = false;
  bool _hidePassword = true;

  @override
  void initState() {
    password = widget.password;
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

  _onBackPressed() {
    widget.onUpdate(password);
    Navigator.pop(context);
  }

  _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  _openDeleteConfirmationDialog() {

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
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => _onBackPressed(),
                              color: Colors.white),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _openDeleteConfirmationDialog(),
                              color: Colors.white),
                        ],
                      ),
                      Text(this.password.name,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () => _openUrl(password.url),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(this.password.url,
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w300)),
                            Icon(Icons.open_in_browser, size: 16)
                          ],
                        ),
                      )
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
                          Text(this.password.login,
                              style: TextStyle(fontSize: 17)),
                          MaterialButton(
                              onPressed: () {},
                              child: Text('Copier'))
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
                          Text(_hidePassword ? this.password.value.replaceAll(new RegExp(r'.'), '*') : this.password.value,
                              style: TextStyle(fontSize: 17)),
                          Row(
                            children: [
                              IconButton(icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => _toggleHidePassword()),
                              MaterialButton(
                                  onPressed: () {},
                                  child: Text('Copier'))
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
              children: [
                BottomButton('Modifier', password.color, () => {})
              ],
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
