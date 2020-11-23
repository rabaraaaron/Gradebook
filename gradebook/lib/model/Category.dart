class Category{

  String categoryName;
  String categoryWeight;
  List<String> categoryItems = new List<String>();
  bool dropLowestScore = false;

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