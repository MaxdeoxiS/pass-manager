import 'dart:async';

import './categories_provider.dart';

class CategoriesBloc {
  final categoriesController = StreamController<List<String>>.broadcast();
  final CategoriesProvider provider = CategoriesProvider();

  Stream get getFavorites => categoriesController.stream;

  void addCategory(String s) {
    provider.addCategory(s);
    categoriesController.sink.add(provider.categories);
  }

  void removeCategory(String s) {
    provider.removeCategory(s);
    categoriesController.sink.add(provider.categories);
  }

  void setCategories(List<String> c) {
    provider.setCategories(c);
    categoriesController.sink.add(provider.categories);
  }

  void dispose() {
    categoriesController.close(); // close our StreamController
  }
}

final blocFavorite = CategoriesBloc();