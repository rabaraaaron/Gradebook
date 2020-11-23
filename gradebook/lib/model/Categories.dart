class Categories{
  bool dropLowestScore = false;
  String categoryName;
  int categoryWeight;
  List<String> categoryItems = new List<String>();

  Categories(String categoryName){
    this.categoryName = categoryName;
  }

  void add(String itemName){
    categoryItems.add(itemName);
  }

  void delete(String itemName){
    categoryItems.remove(itemName);
  }

  void changeDropLowest(bool currentDropLowest){
    dropLowestScore = !currentDropLowest;
  }
}