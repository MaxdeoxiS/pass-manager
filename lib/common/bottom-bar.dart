import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/utils/favorites_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key);
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool filterOnFavorites = false;

  _onFavoritePressed() {
    // Trigger event to update view with favorites only or not
    blocFavorite.toggleFavorites();
    setState(() {
      filterOnFavorites = !filterOnFavorites;
    });
  }

  _onCategoryPressed() {
    // Trigger event to update view with favorites only or not
    // setState(() {
    //   filterOnTags = !filterOnTags;
    // });
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
              icon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primary),
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
              icon: Icon(Icons.loyalty,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => _onCategoryPressed(),
            ),
          ],
        ),
      ),
    );
  }
}
