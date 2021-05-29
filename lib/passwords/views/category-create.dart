import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pass_manager/passwords/utils/CategoryManager.dart';

final List<IconData> icons = [
  Icons.home,
  Icons.lock,
  Icons.language,
  Icons.group,
  Icons.schedule,
  Icons.face,
  Icons.shopping_cart,
  Icons.lightbulb,
  Icons.star,
  Icons.event,
  Icons.work,
  Icons.sentiment_satisfied,
  Icons.photo_camera,
  Icons.map,
  Icons.security,
];

class CategoryCreation extends StatefulWidget {
  CategoryCreation();

  @override
  _CategoryCreationState createState() => _CategoryCreationState();
}

class _CategoryCreationState extends State<CategoryCreation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryManager = CategoryManager.instance;
  int selected = 0;

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: selected == icon.codePoint ? Colors.black : Colors.black12),
      onPressed: () => setState(() {selected = icon.codePoint;}),
      padding: EdgeInsets.all(10),
      iconSize: 50,
    );
  }

  List<Widget> _buildIcons(List<IconData> icons) {
    List<Widget> result = [];
    icons.forEach((icon) {
      result.add(_buildIconButton(icon));
    });
    return result;
  }

  Future<void> _createCategory() async {
    final int icon = this.selected;
    final String name = _nameController.text;
    await _categoryManager.addCategory(name: name, icon: icon);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Créer une nouvelle catégorie')),
      titlePadding: EdgeInsets.symmetric(vertical: 8),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      content: Form(
        key: _formKey,
        child: new Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Nom'.tr(), contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
              ),
          Container(
            height: 100,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: _buildIcons(icons)
                ),
              )
          )
            ],
          ),
    ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('global.cancel'.tr())),
        TextButton(onPressed: () => _createCategory(), child: Text('global.validate'.tr()))
      ],
      actionsPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }
}
