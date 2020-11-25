import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pass_manager/passwords/symbols-selection.dart';

const DIGITS_WEIGHT = 2;
const UPPERCASE_WEIGHT = 2;
const LOWERCASE_WEIGHT = 2;
const SYMBOLS_WEIGHT = 1;

class PasswordGeneration extends StatefulWidget {
  final Color color;

  PasswordGeneration(this.color);

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
  final List<String> _symbols = [
    "!", "#", "\$", "%", "\"", "&", "'", "(", ")", "*", "-", ".",
    ":", ";", "?", "@", "[", "\\", "]", "^", "_", "{", "}", "/",
  ];
  List<String> _lowercase = List<String>();
  List<String> _uppercase = List<String>();
  List<String> _digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List<String> _selectedSymbols = List<String>();

  _PasswordGenerationState() {
    _lowercase = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"
  ];
    _uppercase = _lowercase.map((letter) => letter.toUpperCase()).toList();
  }

  void _generatePassword() {
    var rng = new Random();
    var newPassword = "";
    List<String> alphabet = _buildWeightedAlphabet();
    if (alphabet.length == 0) {
      setState(() {
        _password = "";
      });
      return;
    }
    for (var i = 0; i < _passwordLength; i++) {
      newPassword = newPassword + alphabet[rng.nextInt(alphabet.length - 1)];
    }
    setState(() {
      _password = newPassword;
    });
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  List<String> _buildWeightedAlphabet() {
    List<String> shuffledLower = new List<String>();
    List<String> shuffledUpper = new List<String>();
    List<String> shuffledDigits = new List<String>();
    List<String> shuffledSymbols = new List<String>();

    List<String> allCharacters = List<String>.from([]);

    if (_includeLowercase) {
      shuffledLower = shuffle(_mergeSelf(_lowercase, LOWERCASE_WEIGHT));
      allCharacters..addAll(shuffledLower);
    }
    if (_includeUppercase) {
      shuffledUpper = shuffle(_mergeSelf(_uppercase, UPPERCASE_WEIGHT));
      allCharacters..addAll(shuffledUpper);
    }
    if (_includeDigits) {
      shuffledDigits = shuffle(_mergeSelf(_digits, DIGITS_WEIGHT));
      allCharacters..addAll(shuffledDigits);
    }
    if (_includeSymbols && _selectedSymbols.length > 0) {
      shuffledSymbols = shuffle(_mergeSelf(_selectedSymbols, SYMBOLS_WEIGHT));
      allCharacters..addAll(shuffledSymbols);
    }

    List<String> alphabet = shuffle(allCharacters);
    return alphabet;
  }

  List<String> _mergeSelf(List<String> list, int factor) {
    List<String> newList = new List<String>.from(list);
    for(var i = 1; i < factor; i++) {
      newList..addAll(list);
    }
    return newList;
  }

  List<String> shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  void _handleSymbolsSelection() async {
    List<String> rep = await _showSymbolsSelectionDialog(this.context);
    if (rep != null) {
      setState(() {
        _selectedSymbols = rep;
      });
      this._generatePassword();
    }
  }

  Future<List<String>> _showSymbolsSelectionDialog(BuildContext context) async {
    return await showDialog<List<String>>(
        context: context,
        builder: (BuildContext context) {
          return SymbolsSelection(symbols: _symbols, selected: _selectedSymbols, color: widget.color);
        });
  }

  @override
  void initState() {
    this._generatePassword();
    _selectedSymbols = List<String>.from(_symbols);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
            color: widget.color,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _password,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: _password.length >= 20 ? 15 : 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.cached),
                    tooltip: "Re-générer",
                    color: Colors.white,
                    onPressed: () {
                      _generatePassword();
                    })
              ],
            )),
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
                  this._generatePassword();
                },
              activeColor: widget.color,
              inactiveColor: widget.color.withOpacity(0.5)
            ),
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
              this._generatePassword();
            },
            activeColor: widget.color,
            secondary: Icon(Icons.text_fields, color: widget.color),
        ),
        CheckboxListTile(
          title: const Text('Majuscules'),
          value: _includeUppercase,
          onChanged: (bool value) {
            setState(() {
              _includeUppercase = !_includeUppercase;
            });
            this._generatePassword();
          },
          activeColor: widget.color,
          secondary: Icon(Icons.title, color: widget.color),
        ),
        CheckboxListTile(
          title: const Text('Chiffres'),
          value: _includeDigits,
          onChanged: (bool value) {
            setState(() {
              _includeDigits = !_includeDigits;
            });
            this._generatePassword();
          },
          activeColor: widget.color,
          secondary: Icon(Icons.looks_one, color: widget.color),
        ),
        CheckboxListTile(
          title: Row(
            children: [
              Expanded(
                child: const Text('Symboles'),
              ),
              IconButton(icon: Icon(Icons.settings), color: widget.color, onPressed: () {
                _handleSymbolsSelection();
              }),
            ],
          ),
          value: _includeSymbols,
          onChanged: (bool value) {
            setState(() {
              _includeSymbols = !_includeSymbols;
            });
            this._generatePassword();
          },
          activeColor: widget.color,
          secondary: Icon(Icons.emoji_symbols, color: widget.color),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              color: widget.color,
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