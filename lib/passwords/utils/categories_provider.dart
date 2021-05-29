class CategoriesProvider {
  List<String> categories = [];

  void addCategory(String s) => categories.add(s);
  void removeCategory(String s) => categories.removeWhere((element) => element == s);
  void setCategories(List<String> c) => categories = c;
}