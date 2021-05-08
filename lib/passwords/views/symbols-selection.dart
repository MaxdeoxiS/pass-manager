import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:pass_manager/utils/color.helper.dart';

class SymbolsSelection extends StatefulWidget {
  final List<String> symbols;
  final List<String> selected;
  final Color color;

  SymbolsSelection({required this.symbols, required this.selected, required this.color});

  @override
  _SymbolsSelectionState createState() => _SymbolsSelectionState();
}

class _SymbolsSelectionState extends State<SymbolsSelection> {
  late List<String> _selectedSymbols;

  _toggleSelect(String symbol) {
    if (_selectedSymbols.contains(symbol)) {
      setState(() {
        _selectedSymbols.remove(symbol);
      });
    } else {
      setState(() {
        _selectedSymbols.add(symbol);
      });
    }
  }

  @override
  void initState() {
    _selectedSymbols = List<String>.from(widget.selected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(child: Text('passwords.selectedSymbols'.tr(args: [_selectedSymbols.length.toString(), widget.symbols.length.toString()]))),
        titlePadding: EdgeInsets.symmetric(vertical: 8),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        content: new Container(
          // Specify some width
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .3,
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 6,
              // Generate 100 widgets that display their index in the List.
              children: widget.symbols
                  .map((sym) => FlatButton(
                        onPressed: () => _toggleSelect(sym),
                        color: _selectedSymbols.contains(sym)
                            ? widget.color
                            : Colors.white,
                        textColor: ColorHelper.getTextContrastedColor(_selectedSymbols.contains(sym) ? widget.color : Colors.white),
                        child: Text(
                          '$sym',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: _selectedSymbols.contains(sym)
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ))
                  .toList()),
        ),
        actions: [
          FlatButton(onPressed: () => Navigator.pop(context), child: Text('global.cancel'.tr(), style: TextStyle(color: widget.color))),
          FlatButton(onPressed: () => Navigator.pop(context, _selectedSymbols), child: Text('global.validate'.tr(), style: TextStyle(color: widget.color)))
        ],
      actionsPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }
}
