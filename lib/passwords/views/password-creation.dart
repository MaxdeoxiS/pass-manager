import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/passwords/utils/PasswordManager.dart';
import 'package:pass_manager/passwords/utils/scraper.dart';
import 'package:pass_manager/passwords/views/category-selection.dart';
import 'package:pass_manager/utils/color.helper.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:pass_manager/passwords/views/password-generation.dart';

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
  bool nameIsFilled = false;
  Category? category;

  final _passwordManager = PasswordManager.instance;
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _nameController.addListener(_onNameChange);
  }

  Future<void> insertPassword() async {
    if (_formKey.currentState!.validate()) {
      await _passwordManager.addPassword(
          login: _loginController.text,
          value: _passwordController.text,
          name: _nameController.text,
          url: _urlController.text,
          comment: _commentController.text,
          color: currentColor,
          isFavorite: isFavorite,
          category: (category != null) ? category : null);
      Navigator.pushReplacementNamed(context, "/passwords");
    }
  }

  void _handlePasswordGeneration() async {
    String? rep = await _showPasswordGenerationDialog(this.context, currentColor);
    setState(() {
      _passwordController.text = rep!;
    });
  }

  void _onNameChange() {
    setState(() {
      nameIsFilled = _nameController.text.length > 0;
    });
  }

  void _handleUrlGeneration() async {
    String url = await Scraper.scrapResults(_nameController.text);
    setState(() {
      _urlController.text = url;
    });
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  void _showColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('password.colorChoice'.tr()),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: currentColor,
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
      category = pickedCategory;
    });
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
    Color contrastedColor = ColorHelper.getTextContrastedColor(currentColor);
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('passwords.addPassword'.tr(), style: TextStyle(color: contrastedColor)),
        backgroundColor: currentColor,
        iconTheme: IconThemeData(color: contrastedColor),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ ne peut pas être vide';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'passwords.login'.tr(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                      autofillHints: [AutofillHints.givenName],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ ne peut pas être vide';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'passwords.password'.tr(),
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              isDense: true,
                              suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: currentColor),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  })),
                          obscureText: !_passwordVisible,
                        )),
                        TextButton(
                            onPressed: () => _handlePasswordGeneration(),
                            child: Text('passwords.generate'.tr(), style: TextStyle(color: currentColor)))
                      ],
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ ne peut pas être vide';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'passwords.siteName'.tr(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          isDense: true),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: _urlController,
                          decoration: InputDecoration(
                              labelText: 'URL'.tr(), contentPadding: EdgeInsets.symmetric(vertical: 0), isDense: true),
                        )),
                        TextButton(
                            onPressed: _nameController.text.length > 0 ? (() => _handleUrlGeneration()) : null,
                            child: Text('passwords.generate'.tr(), style: TextStyle(color: currentColor)))
                      ],
                    ),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          labelText: 'passwords.comment'.tr(),
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
                      TextButton(
                        onPressed: () => _showColorPicker(),
                        child: Icon(Icons.circle, color: contrastedColor),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(currentColor),
                        ),
                      ),
                      IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline, size: 30),
                          onPressed: () => _toggleFavorite(),
                          color: currentColor),
                      TextButton(
                        onPressed: () => _showCategoryPicker(),
                        child: (null == category)
                            ? Text('Catégorie'.tr(), style: TextStyle(color: contrastedColor))
                            : Icon(IconData(category?.icon ?? 0, fontFamily: 'MaterialIcons'), color: contrastedColor),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(currentColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                          onPressed: () => insertPassword(),
                          child: Text('global.create'.tr(), style: TextStyle(color: contrastedColor)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(currentColor),
                          ))))
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _showPasswordGenerationDialog(BuildContext context, Color color) async {
  return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PasswordGeneration(color);
      });
}
