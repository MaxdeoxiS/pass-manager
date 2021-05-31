import 'package:badges/badges.dart';
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
  final _searchController = TextEditingController();
  bool searchNotEmpy = false;

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
      setState(() {
        activeCategories = [];
      });
      blocFilter.setCategories([]);
    }
  }

  _onSearchPressed() async {
    String? result = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: new Container(
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search something",
                    ),
                  )));
        });
      setState(() {
        searchNotEmpy = _searchController.text.length > 0;
      });
  }

  _onSearchUpdated() {
    blocFilter.setSearch(_searchController.text);
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _searchController.addListener(_onSearchUpdated);
  }

  @override
  void dispose() {
    // other dispose methods
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(searchNotEmpy);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: [
            IconButton(
              tooltip: "bottomBar.search".tr(),
              icon: Badge(showBadge: searchNotEmpy, animationType: BadgeAnimationType.scale, child: Icon(Icons.search, color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                _onSearchPressed();
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
              icon: Badge(showBadge: activeCategories.length > 0, animationType: BadgeAnimationType.scale, child: Icon(Icons.loyalty, color: Theme.of(context).colorScheme.primary)),
              onPressed: () => _onCategoryPressed(),
            ),
            (filterOnFavorites || _searchController.text.length > 0 || activeCategories.length > 0) ?
            IconButton(
              tooltip: "bottomBar.categoryFilter".tr(),
              icon: Icon(Icons.clear_outlined, color: Theme.of(context).colorScheme.primary),
              onPressed: () => _onCategoryPressed(),
            ) : Icon(Icons.file_download),
          ],
        ),
      ),
    );
  }
}
