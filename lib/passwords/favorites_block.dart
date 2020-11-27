import 'dart:async';

import 'favorites_provider.dart';

class FavoritesBloc {
  final counterController = StreamController(); // create a StreamController
  final FavoritesProvider provider = FavoritesProvider(); // create an instance of our CounterProvider

  Stream get getFavorites => counterController.stream; // create a getter for our stream

  void toggleFavorites() {
    provider.toggleFavorites(); // call the method to increase our count in the provider
    counterController.sink.add(provider.favorites); // add the count to our sink
  }

  void dispose() {
    counterController.close(); // close our StreamController
  }
}

final bloc = FavoritesBloc(); // create an instance of the counter bloc