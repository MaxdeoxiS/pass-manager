import 'package:flutter/material.dart';

import '../database.helper.dart';
import 'package:pass_manager/passwords/password-generation.dart';
import 'entity/password.entity.dart';

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
  bool _passwordVisible = false;

  final dbHelper = DatabaseHelper.instance;

  Future<void> insertPassword() async {
    final passwordDao = await dbHelper.getPasswordDao();;
    Password password = new Password(null, _nameController.text, _loginController.text, _passwordController.text, _urlController.text, _commentController.text);
    await passwordDao.insertPassword(password);

    final result = await passwordDao.findAllPasswords();
    print(result);
  }

  void _handlePasswordGeneration() async {
    String rep = await _showPasswordGenerationDialog(this.context);
    setState(() {
      _passwordController.text = rep;
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
        title: Text('Ajouter un mot de passe'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
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
                                      : Icons.visibility),
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
                ],
              ),
              Expanded(
                  child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () => insertPassword(), child: Text("Créer"))))
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> _showPasswordGenerationDialog(BuildContext context) async {
  return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PasswordGeneration();
      });
}
