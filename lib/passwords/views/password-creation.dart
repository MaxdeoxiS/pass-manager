import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pass_manager/utils/color.helper.dart';

import '../../utils/database/database.helper.dart';
import 'package:pass_manager/passwords/views/password-generation.dart';
import '../entity/password.entity.dart';

class PasswordCreation extends StatefulWidget {
  @override
  _PasswordCreationState createState() => _PasswordCreationState();
}

class _PasswordCreationState extends State<PasswordCreation> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _commentController = TextEditingController();
  Color currentColor = Color(0xff607d8b);
  bool _passwordVisible = false;
  bool isFavorite = false;

  final dbHelper = DatabaseHelper.instance;

  Future<void> insertPassword() async {
    final passwordDao = await dbHelper.getPasswordDao();
    Password password = new Password(
        _nameController.text,
        _loginController.text,
        _passwordController.text,
        _urlController.text,
        _commentController.text,
        new DateTime.now(),
        currentColor,
        isFavorite
    );
    await passwordDao.insertPassword(password);
    Navigator.pushReplacementNamed(context, "/passwords");
  }

  void _handlePasswordGeneration() async {
    String rep = await _showPasswordGenerationDialog(this.context, currentColor);
    setState(() {
      _passwordController.text = rep;
    });
  }

  void changeColor(Color color) {
    print(color);
    setState(() => currentColor = color);
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
             pickerColor: currentColor,
             onColorChanged: changeColor,
           ),
        )
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void dispose() {
    // other dispose methods
    _loginController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un mot de passe', style: TextStyle(color: ColorHelper.getTextContrastedColor(currentColor))),
        backgroundColor: currentColor,
        iconTheme: IconThemeData(color: ColorHelper.getTextContrastedColor(currentColor)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    TextFormField(
                      controller: _loginController,
                      decoration: InputDecoration(
                          labelText: 'Identifiant',
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                      autofillHints: [AutofillHints.givenName],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              isDense: true,
                              suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility, color: currentColor),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  })),
                          obscureText: !_passwordVisible,
                        )),
                        FlatButton(
                            onPressed: () => _handlePasswordGeneration(), child: Text("Générer"))
                      ],
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Nom du site',
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                    ),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                          labelText: 'URL',
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                      autofillHints: <String>[AutofillHints.streetAddressLine1],
                    ),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          labelText: 'Commentaire',
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                      maxLines: 2,
                    ),
                  ].expand(
                    (widget) => [
                      widget,
                      SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      FlatButton(onPressed: () => _showColorPicker(), child: Text("Couleur", style: TextStyle(color: ColorHelper.getTextContrastedColor(currentColor))), color: currentColor),
                      IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline, size: 30), onPressed: () => _toggleFavorite(), color: currentColor),
                    ],
                  )
                ],
              ),
              Expanded(
                  child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                          onPressed: () => insertPassword(),
                          child: Text("Créer", style: TextStyle(color: ColorHelper.getTextContrastedColor(currentColor))),
                          color: currentColor)
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> _showPasswordGenerationDialog(BuildContext context, Color color) async {
  return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PasswordGeneration(color);
      });
}
