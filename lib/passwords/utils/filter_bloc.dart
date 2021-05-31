import 'dart:async';

import './filter_provider.dart';
import 'Filter.dart';

class FilterBloc {
  final filterController = StreamController<Filter>.broadcast();
  final FilterProvider provider = FilterProvider();

  Stream get getFilter => filterController.stream;

  // Favorites
  void toggleFavorites() {
    provider.toggleFavorites();
    update();
  }

  // Categories
  void addCategory(String s) {
    provider.addCategory(s);
    update();
  }

  void removeCategory(String s) {
    provider.removeCategory(s);
    update();
  }

  void setCategories(List<String> c) {
    provider.setCategories(c);
    update();
  }

  // Search
  void setSearch(String? query) {
    provider.setSearch(query);
    update();
  }

  void update() {
    filterController.sink.add(provider.filter);
  }

  void dispose() {
    filterController.close(); // close our StreamController
  }
}

final blocFilter = FilterBloc();