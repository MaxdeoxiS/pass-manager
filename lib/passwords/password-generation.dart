import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PasswordGeneration extends StatefulWidget {
  @override
  _PasswordGenerationState createState() => _PasswordGenerationState();
}

class _PasswordGenerationState extends State<PasswordGeneration> {
  int _passwordLength = 10;
  String _password = "";
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeDigits = true;
  bool _includeSymbols = true;

  final String alphabet = 'abcdefghijklmnopqrstuvwxyz1234567890:;,!?./§%^-_';

  void _generatePassword() {
    var rng = new Random();
    var newPassword = "";
    for (var i = 0; i < _passwordLength; i++) {
      newPassword = newPassword + alphabet[rng.nextInt(alphabet.length - 1)];
    }
    setState(() {
      _password = newPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: Text(
                _password,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: _password.length >= 20 ? 18 : 22, fontWeight: FontWeight.bold),
              ),),

              IconButton(icon: Icon(Icons.cached), tooltip: "Re-générer", color: Colors.white, onPressed: () { _generatePassword();})
            ],
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Text(_passwordLength.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("caractères", style: TextStyle(fontSize: 12))
            ]),
            Slider(
                min: 6,
                max: 30,
                divisions: 24,
                label: _passwordLength.round().toString(),
                value: _passwordLength.toDouble(),
                onChanged: (newValue) {
                  setState(() {
                    _passwordLength = newValue.round();
                  });
                }),
          ],
        ),
        Divider(),
        CheckboxListTile(
          title: const Text('Minuscules'),
          value: _includeLowercase,
          onChanged: (bool value) {
            setState(() {
              _includeLowercase = !_includeLowercase;
            });
          },
          secondary: const Icon(Icons.text_fields)
        ),
        CheckboxListTile(
          title: const Text('Majuscules'),
          value: _includeUppercase,
          onChanged: (bool value) {
            setState(() {
              _includeUppercase = !_includeUppercase;
            });
          },
          secondary: const Icon(Icons.title),
        ),
        CheckboxListTile(
          title: const Text('Chiffres'),
          value: _includeDigits,
          onChanged: (bool value) {
            setState(() {
              _includeDigits = !_includeDigits;
            });
          },
          secondary: const Icon(Icons.looks_one),
        ),
        CheckboxListTile(
          title: const Text('Symboles'),
          value: _includeSymbols,
          onChanged: (bool value) {
            setState(() {
              _includeSymbols = !_includeSymbols;
            });
          },
          secondary: Icon(Icons.emoji_symbols),
        ),
        ListTile(
          title: const Text('Plus de paramètres...'),
          leading: Icon(Icons.settings),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context, _password);
              },
              child: const Text('Valider'),
            ),
          ],
        )
      ],
    );
    ;
  }
}
