import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/utils/favorites_block.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool filterOnFavorites = false;

  _onFavoritePressed() {
    // Trigger event to update view with favorites only or not
    bloc.toggleFavorites();
    setState(() {
      filterOnFavorites = !filterOnFavorites;
    });
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
              tooltip: "Rechercher",
              icon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                print('Search button pressed');
              },
            ),
            IconButton(
              tooltip: "Filtrer sur les favoris",
              icon: Icon(filterOnFavorites ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => _onFavoritePressed(),
            ),
          ],
        ),
      ),
    );
  }
}
