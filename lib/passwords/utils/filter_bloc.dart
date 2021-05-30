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
    filterController.sink.add(provider.filter);
  }

  // Categories
  void addCategory(String s) {
    provider.addCategory(s);
    filterController.sink.add(provider.filter);
  }

  void removeCategory(String s) {
    provider.removeCategory(s);
    filterController.sink.add(provider.filter);
  }

  void setCategories(List<String> c) {
    provider.setCategories(c);
    filterController.sink.add(provider.filter);
  }

  void dispose() {
    filterController.close(); // close our StreamController
  }
}

final blocFilter = FilterBloc();