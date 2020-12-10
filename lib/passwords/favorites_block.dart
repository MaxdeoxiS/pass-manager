import 'dart:async';

import 'favorites_provider.dart';

class FavoritesBloc {
  final counterController = StreamController<bool>.broadcast();
  final FavoritesProvider provider = FavoritesProvider();

  Stream get getFavorites => counterController.stream;

  void toggleFavorites() {
    provider.toggleFavorites();
    counterController.sink.add(provider.favorites);
  }

  void dispose() {
    counterController.close(); // close our StreamController
  }
}

final bloc = FavoritesBloc();