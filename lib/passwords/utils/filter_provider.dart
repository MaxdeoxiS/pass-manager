import 'Filter.dart';

class FilterProvider {
   Filter filter = Filter(
     search: null,
     categories: [],
     favorites: false
   );

   // Favorites
   void toggleFavorites() => filter.favorites = !filter.favorites;
   void disableFavorites() => filter.favorites = false;

   // Categories
  void addCategory(String s) => filter.categories.add(s);
  void removeCategory(String s) => filter.categories.removeWhere((element) => element == s);
  void setCategories(List<String> c) => filter.categories = c;

  // Search
  void setSearch(String? query) => filter.search = query;
}