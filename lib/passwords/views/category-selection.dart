import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/passwords/utils/CategoryManager.dart';
import 'package:pass_manager/passwords/views/category-create.dart';

class CategorySelection extends StatefulWidget {
  final bool? hideActions;
  final String title;
  final bool? selectOnTap;
  final List<String>? selectedItems;
  CategorySelection({this.hideActions, required this.title, this.selectOnTap, this.selectedItems});

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final _categoryManager = CategoryManager.instance;
  List<Category> items = [];
  List<String> activeItems = [];

  void _updateList() async {
    List<Category> categories = await _categoryManager.getCategories();
    setState(() {
      items = categories;
    });
  }

  void _setActiveItems(List<String> actives) async {
    setState(() {
      activeItems = actives;
    });
  }

  void _showCategoryCreation() async {
    bool? created = await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return CategoryCreation();
        });
    // Re-render list if a new item has been created
    if (null != created && true == created) {
      _updateList();
    }
  }

  void _onItemTap(Category category) {
    // If tapping the item is handled by parent
    if (true == this.widget.selectOnTap) {
      Navigator.pop(context, category);
    } else {
      setState(() {
        if (activeItems.contains(category.name)) {
          activeItems.remove(category.name);
        } else {
          activeItems.add(category.name);
        }
      });
    }
  }

  void _deleteCategory(Category category) async {
    bool? delete = await _showCategoryDeletionDialog(this.context);
    int? id = category.id;
    if (null != id && null != delete && true == delete) {
      _categoryManager.deleteCategory(id);
      _updateList();
    }
  }

  @override
  void initState() {
    _updateList();
    if (null != widget.selectedItems) {
      _setActiveItems(widget.selectedItems!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(this.widget.title)),
      titlePadding: EdgeInsets.symmetric(vertical: 16),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      content: new Container(
          height: 500,
          width: 300,
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return ListTile(
                  title: Text('Ajouter une catégorie...'),
                  onTap: () => _showCategoryCreation(),
                );
              }
              Category category = items[index];
              return ListTile(
                leading: this.widget.selectOnTap != null ? null : Icon(this.activeItems.contains(category.name) ? Icons.check_box_rounded : Icons.check_box_outline_blank_sharp),
                title: Text('${category.name}'),
                trailing: Icon(IconData(category.icon, fontFamily: "MaterialIcons")),
                onTap: () => _onItemTap(category),
                onLongPress: () => _deleteCategory(category),
              );
            },
          )),
      actions: (this.widget.hideActions == true)
          ? []
          : [
              TextButton(onPressed: () => Navigator.pop(context, activeItems), child: Text('global.validate'.tr()))
            ],
      actionsPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }
}

Future<bool?> _showCategoryDeletionDialog(BuildContext context) async {
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