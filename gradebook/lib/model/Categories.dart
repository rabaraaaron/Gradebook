class Categories{
  String categoryName;
  List<String> categoryItems = new List<String>();
  bool dropLowestScore = false;

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