import 'dart:async';

import 'favorites_provider.dart';

class FavoritesBloc {
  final favoritesController = StreamController<bool>.broadcast();
  final FavoritesProvider provider = FavoritesProvider();

  Stream get getFavorites => favoritesController.stream;

  void toggleFavorites() {
    provider.toggleFavorites();
    favoritesController.sink.add(provider.favorites);
  }

  void dispose() {
    favoritesController.close(); // close our StreamController
  }
}

final bloc = FavoritesBloc();