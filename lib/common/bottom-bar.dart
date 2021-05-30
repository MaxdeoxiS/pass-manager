import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/passwords/utils/filter_bloc.dart';
import 'package:pass_manager/passwords/views/category-selection.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key);
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool filterOnFavorites = false;
  List<String> activeCategories = [];

  _onFavoritePressed() {
    // Trigger event to update view with favorites only or not
    blocFilter.toggleFavorites();
    setState(() {
      filterOnFavorites = !filterOnFavorites;
    });
  }

  _onCategoryPressed() async {
    List<String>? categories = await showDialog<List<String>>(
        context: context,
        builder: (BuildContext context) {
          return CategorySelection(title: "Filtrer par catégories", selectedItems: activeCategories);
        });
    if (null != categories && categories.length > 0) {
      blocFilter.setCategories(categories);
      setState(() {
        activeCategories = categories;
      });
    } else {
      blocFilter.setCategories([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: [
            IconButton(
              tooltip: "bottomBar.search".tr(),
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                print('Search button pressed');
              },
            ),
            IconButton(
              tooltip: "bottomBar.favoriteFilter".tr(),
              icon: Icon(filterOnFavorites ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => _onFavoritePressed(),
            ),
            IconButton(
              tooltip: "bottomBar.categoryFilter".tr(),
              icon: Icon(Icons.loyalty, color: Theme.of(context).colorScheme.primary),
              onPressed: () => _onCategoryPressed(),
            ),
          ],
        ),
      ),
    );
  }
}
