class Category{

  String categoryName;
  String categoryWeight;
  List<String> categoryItems = new List<String>();
  bool dropLowestScore = false;
  String id;
  double totalPoints =0;
  double totalEarnedPoints = 0;

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
  void addToTotalPoints(double points){
    totalPoints += points;
  }
  void resetTotolPoints(){
    totalPoints = 0;
  }
}