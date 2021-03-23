import 'package:gradebook/model/Assessment.dart';

class Category{

  String categoryName;
  String categoryWeight = '0';
  // List<Assessment> categoryItems;
  bool dropLowestScore = false;
  String id;
  //double totalPoints = 0.0;
  //double totalEarnedPoints = 0.0;
  Assessment lowest;

  String total, earned;


  Category({
    this.categoryName,
    this.categoryWeight,
    this.id,
    this.dropLowestScore,
    this.total,
    this.earned
  });


  // void delete(String itemName){
  //   categoryItems.remove(itemName);
  // }

  void changeDropLowest(bool currentDropLowest){
    dropLowestScore = !currentDropLowest;
  }
  // void addToTotalPoints(double points){
  //   totalPoints += points;
  // }
  // void resetTotolPoints(){
  //   totalPoints = 0;
  // }
  // void dropLowest() {
  //   //print(categoryItems);
  //   for(Assessment a in categoryItems){
  //     a.dropped = false;
  //   }
  //   categoryItems.sort((a, b) => (a.yourPoints/a.totalPoints).compareTo(b.yourPoints/b.totalPoints));
  //   categoryItems.first.dropped = true;
  //
  // }

  // @override
  // String toString() {
  //   return {categoryName, categoryItems}.toString();
  // }

}