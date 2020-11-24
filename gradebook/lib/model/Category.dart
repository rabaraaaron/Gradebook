class Category{

  String categoryName;
  String categoryWeight;
  List<String> categoryItems = new List<String>();
  bool dropLowestScore = false;
  String id;

  Category({
    this.categoryName,
    this.categoryWeight,
    this.id
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