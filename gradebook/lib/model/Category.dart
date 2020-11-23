class Category{
  bool dropLowestScore = false;
  String categoryName;
  int categoryWeight;
  List<String> categoryItems = new List<String>();

  Category({
    this.categoryName,
    this.categoryWeight,
  });

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