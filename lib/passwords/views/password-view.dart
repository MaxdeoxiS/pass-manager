import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/views/password-generation.dart';
import 'package:pass_manager/passwords/views/passwords-list.dart';
import 'package:pass_manager/utils/color.helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../entity/password.entity.dart';

const DEFAULT_COLOR = Colors.red;

enum MenuOption { edit, color, delete }

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
  Color _currentColor;
  final _loginController = TextEditingController();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    password = widget.password;
    _loginController.text = password.login;
    _urlController.text = password.url;
    _nameController.text = password.name;
    _passwordController.text = password.value;
    _commentController.text = password.comment;
    _currentColor = password.color;
    super.initState();
  }

  _toggleFavorite() {
    setState(() {
      password.isFavorite = !password.isFavorite;
      widget.onUpdate(password);
    });
  }

  _updatePassword() {
    // If password has changed, update 'last password update'
    if (password.value != _passwordController.text) {
      password.updated = DateTime.now();
    }
    password.login = _loginController.text;
    password.url = _urlController.text;
    password.name = _nameController.text;
    password.value = _passwordController.text;
    password.comment = _commentController.text;
    password.color = _currentColor;
    widget.onUpdate(password);
    setState(() {
      _isEditing = !_isEditing;
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

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    password.color = _currentColor;
    widget.onUpdate(password);
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Choix de la couleur'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _currentColor,
                onColorChanged: changeColor,
              ),
            ));
      }
    );
  }

  void _handleMenuClick(MenuOption action) {
    switch (action) {
      case MenuOption.edit:
        {
          _toggleEdit();
        }
        break;
      case MenuOption.color:
        {
          _showColorPicker();
        }
        break;
      case MenuOption.delete:
        {
          _handlePasswordDeletion();
        }
        break;
      default:
        {
          print("Invalid action");
        }
    }
  }

  @override
  void dispose() {
    // other dispose methods
    _loginController.dispose();
    _urlController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  DateFormat format = new DateFormat("dd/MM/yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: _currentColor ?? DEFAULT_COLOR,
                    height: MediaQuery.of(context).size.height * .2,
                    padding: EdgeInsets.only(top: 24),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => _onBackPressed(),
                                color: ColorHelper.getTextContrastedColor(_currentColor)),
                            PopupMenuButton<MenuOption>(
                              icon: Icon(Icons.more_vert, color: ColorHelper.getTextContrastedColor(_currentColor)),
                              onSelected: (MenuOption result) {
                                _handleMenuClick(result);
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
                                const PopupMenuItem<MenuOption>(
                                  value: MenuOption.edit,
                                  child: Text('Modifier'),
                                ),
                                const PopupMenuItem<MenuOption>(
                                  value: MenuOption.color,
                                  child: Text('Changer la couleur'),
                                ),
                                const PopupMenuItem<MenuOption>(
                                  value: MenuOption.delete,
                                  child: Text('Supprimer'),
                                ),
                              ],
                            )
                          ],
                        ),
                        _isEditing
                            ? Container(width: 100, child: TextField(controller: _nameController))
                            : Text(_nameController.text,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: ColorHelper.getTextContrastedColor(_currentColor))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(password.isFavorite ? Icons.favorite : Icons.favorite_outline,
                                  color: ColorHelper.getTextContrastedColor(password.color)),
                              onPressed: () => _toggleFavorite(),
                            )
                          ],
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
                    FieldRow(_loginController, _isEditing, 'login'.tr(), []),
                    FieldRow(
                        _passwordController,
                        _isEditing,
                        'Mot de passe',
                        [
                          _isEditing
                              ? (IconButton(icon: Icon(Icons.refresh), onPressed: () => _handlePasswordGeneration()))
                              : Container(),
                          IconButton(
                              icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => _toggleHidePassword())
                        ],
                        _hidePassword),
                    FieldRow(_urlController, _isEditing, 'URL',
                        [IconButton(icon: Icon(Icons.open_in_browser), onPressed: () => _openUrl(password.url))]),
                    FieldRow(_commentController, _isEditing, 'Commentaire', []),
                    // FieldRow(_loginController, _isEditing, 'Expiration', [IconButton(icon: Icon(Icons.open_in_browser), onPressed: () => _openUrl(password.url))]),
                    Label('Dernière mise à jour du mot de passe'),
                    Text(format.format(this.password.updated)),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _isEditing ? [
                  Row(
                    children: <Widget>[
                      Expanded(child: BottomButton('Valider', _currentColor, _updatePassword)),
                      Expanded(child: BottomButton('Annuler', _currentColor, _toggleEdit)),
                    ],
                  )
                ] : [],
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false);
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

class EditableField extends StatelessWidget {
  final TextEditingController controller;
  final bool editing;
  final bool hide;

  EditableField(this.controller, this.editing, [this.hide = false]);

  String _hide(String text) {
    return text.replaceAll(new RegExp(r'.'), '*');
  }

  String _displayValue(String text) {
    if (this.hide) {
      return this._hide(controller.text);
    } else {
      return (controller.text != null && controller.text.length > 0) ? controller.text : '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return (this.editing
        ? Expanded(
            child: TextField(
                controller: controller,
                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
                obscureText: this.hide))
        : Text(_displayValue(controller.text), style: TextStyle(fontSize: 16)));
  }
}

class FieldRow extends StatelessWidget {
  final TextEditingController controller;
  final bool editing;
  final String label;
  final bool hide;
  final List<Widget> actions;

  FieldRow(this.controller, this.editing, this.label, this.actions, [this.hide = false]);

  void _copyText(BuildContext context) {
    FlutterClipboard.copy(controller.text);
    final snackBar = SnackBar(content: Text(label + ' copié(e) !'), duration: Duration(milliseconds: 1250));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Label(label),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            EditableField(controller, editing, hide),
            Row(children: [
              ...actions.map((widget) => widget).toList(),
              IconButton(icon: Icon(Icons.copy), onPressed: () => _copyText(context))
            ])
          ],
        ),
      ],
    );
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
          child: Text(this.label, style: TextStyle(color: ColorHelper.getTextContrastedColor(color))),
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
          title: Text("Attention"),
          content: Text("Voulez-vous supprimer le mot de passe ?"),
          actions: [
            FlatButton(child: Text("Annuler"), onPressed: () => Navigator.pop(context, false)),
            FlatButton(child: Text("Supprimer"), onPressed: () => Navigator.pop(context, true))
          ],
        );
      });
}
