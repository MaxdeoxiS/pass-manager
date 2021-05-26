import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryCreation extends StatefulWidget {
  CategoryCreation();

  @override
  _CategoryCreationState createState() => _CategoryCreationState();
}

class _CategoryCreationState extends State<CategoryCreation> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text('Créer une nouvelle catégorie')),
      titlePadding: EdgeInsets.symmetric(vertical: 8),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      content: new Container(
        // Specify some width
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('global.cancel'.tr())),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('global.validate'.tr()))
      ],
      actionsPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }
}
