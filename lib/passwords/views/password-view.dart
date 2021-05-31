import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/views/password-generation.dart';
import 'package:pass_manager/passwords/views/passwords-list.dart';
import 'package:pass_manager/utils/color.helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';

import '../entity/password.entity.dart';
import 'category-selection.dart';

const DEFAULT_COLOR = Colors.red;

enum MenuOption { color, duplicate, delete }

class PasswordView extends StatefulWidget {
  final DeleteCallback onDelete;
  final UpdateCallback onUpdate;
  final Password password;

  PasswordView({Key? key, required this.onDelete, required this.onUpdate, required this.password}) : super(key: key);
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  late Password password;
  bool _isEditing = false;
  bool _hidePassword = true;
  late Color _currentColor;
  late Category? _currentCategory;
  final _loginController = TextEditingController();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _commentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _favoriteController = TextEditingController();

  @override
  void initState() {
    password = widget.password;
    _loginController.text = password.login;
    _urlController.text = password.url ?? "";
    _nameController.text = password.name;
    _passwordController.text = password.value;
    _commentController.text = password.comment ?? "";
    _currentColor = password.color;
    _currentCategory = password.category;
    _categoryController.text = password.category?.name ?? '-';
    _favoriteController.text = password.isFavorite ? 'Oui' : 'Non';
    super.initState();
  }

  _toggleFavorite() {
    setState(() {
      password.isFavorite = !password.isFavorite;
      _favoriteController.text = password.isFavorite ? 'Oui' : 'Non';
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
  }

  _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  _toggleEdit() {
    if (_isEditing) {
      _updatePassword();
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  _onBackPressed() {
    Navigator.pop(context);
  }

  void _openUrl(String? url) async {
    if (null == url) {
      return;
    }
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _handlePasswordGeneration() async {
    String? rep = await _showPasswordGenerationDialog(this.context, this.password.color);
    setState(() {
      _passwordController.text = rep!;
    });
  }

  void _handlePasswordDeletion() async {
    bool? delete = await _showPasswordDeletionDialog(this.context);
    int? id = password.id;
    if (null != delete && true == delete && null != id) {
      widget.onDelete(id);
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
              title: Text('passwords.colorChoice'.tr()),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _currentColor,
                  onColorChanged: changeColor,
                ),
              ));
        });
  }

  void _showCategoryPicker() async {
    Category? pickedCategory = await showDialog<Category?>(
        context: context,
        builder: (BuildContext context) {
          return CategorySelection(title: "Sélection de la catégorie", hideActions: true, selectOnTap: true);
        });
    setState(() {
      _currentCategory = pickedCategory;
      _categoryController.text = pickedCategory?.name ?? '-';
    });
    password.category = _currentCategory;
    widget.onUpdate(password);
  }

  void _handleMenuClick(MenuOption action) {
    switch (action) {
      case MenuOption.color:
        {
          _showColorPicker();
        }
        break;
      case MenuOption.duplicate:
        {
          // _showCategoryPicker();
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
    _categoryController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  DateFormat format = new DateFormat("dd/MM/yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    Color contrastedColor = ColorHelper.getTextContrastedColor(_currentColor);
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: _currentColor,
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
                                color: contrastedColor),
                            PopupMenuButton<MenuOption>(
                              icon: Icon(Icons.more_vert, color: contrastedColor),
                              onSelected: (MenuOption result) {
                                _handleMenuClick(result);
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
                                PopupMenuItem<MenuOption>(
                                  value: MenuOption.color,
                                  child: Text('passwords.editColor'.tr()),
                                ),
                                PopupMenuItem<MenuOption>(
                                  value: MenuOption.duplicate,
                                  child: Text('Dupliquer'.tr()),
                                ),
                                PopupMenuItem<MenuOption>(
                                  value: MenuOption.delete,
                                  child: Text('passwords.delete'.tr()),
                                ),
                              ],
                            )
                          ],
                        ),
                        _isEditing
                            ? Container(width: 100, child: TextField(controller: _nameController))
                            : Text(_nameController.text,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: contrastedColor)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    _toggleEdit();
                                  },
                                  child: Text(_isEditing ? 'Valider' : 'Modifier',
                                      style: TextStyle(color: contrastedColor)),
                                ))
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
                    FieldRow(_loginController, _isEditing, 'passwords.login'.tr(), []),
                    FieldRow(
                        _passwordController,
                        _isEditing,
                        'passwords.password'.tr(),
                        [
                          _isEditing
                              ? (IconButton(icon: Icon(Icons.refresh), onPressed: () => _handlePasswordGeneration()))
                              : Container(),
                          IconButton(
                              icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => _toggleHidePassword())
                        ],
                        _hidePassword),
                    InkWell(
                        onTap: () {
                          if (_isEditing) {
                            _showCategoryPicker();
                          }
                        },
                        child: StaticFieldRow(_categoryController, 'Catégorie'.tr(), _isEditing)),
                    InkWell(
                        onTap: () {
                          if (_isEditing) {
                            _toggleFavorite();
                          }
                        },
                        child: StaticFieldRow(_favoriteController, 'Favori'.tr(), _isEditing)),
                    // StaticFieldRow('Favori'.tr(), password.isFavorite ? 'Oui' : 'Non', _isEditing, []),
                    FieldRow(_urlController, _isEditing, 'passwords.URL'.tr(),
                        [IconButton(icon: Icon(Icons.open_in_browser), onPressed: () => _openUrl(password.url))]),
                    FieldRow(_commentController, _isEditing, 'passwords.comment'.tr(), []),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label('passwords.lastUpdate'.tr() + ' le ' + format.format(this.password.updated)),
                    ],
                  ),
                )),
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

  String _displayValue() {
    if (this.hide) {
      return this._hide(controller.text);
    } else {
      return (controller.text.length > 0) ? controller.text : '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.editing
        ? TextField(
            controller: controller,
            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
            obscureText: this.hide)
        : Text(_displayValue(), style: TextStyle(fontSize: 16));
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
    final snackBar =
        SnackBar(content: Text('passwords.copied'.tr(args: [label])), duration: Duration(milliseconds: 1250));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(label),
            Container(width: 200, height: 40, child: EditableField(controller, editing, hide)),
          ],
        ),
        Row(children: [
          ...actions.map((widget) => widget).toList(),
          IconButton(icon: Icon(Icons.copy), onPressed: () => _copyText(context))
        ])
      ],
    );
  }
}

class StaticFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool editing;

  StaticFieldRow(this.controller, this.label, this.editing);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(label),
            Container(
                width: 200,
                height: 40,
                child: editing
                    ? TextField(
                        enabled: false,
                        controller: controller,
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true))
                    : Text(controller.text, style: TextStyle(fontSize: 16)))
          ],
        ));
  }
}

Future<String?> _showPasswordGenerationDialog(BuildContext context, Color color) async {
  return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PasswordGeneration(color);
      });
}

Future<bool?> _showPasswordDeletionDialog(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('global.warning'.tr()),
          content: Text('password.confirmDelete'.tr()),
          actions: [
            TextButton(child: Text('global.cancel'.tr()), onPressed: () => Navigator.pop(context, false)),
            TextButton(child: Text('global.delete'.tr()), onPressed: () => Navigator.pop(context, true))
          ],
        );
      });
}
