import 'package:gradebook/model/Assessment.dart';

class Category {

  String categoryName;
  double categoryWeight = 0;
  List<Assessment> categoryItems;
  bool dropLowestScore = false;
  int numberDropped;
  bool equalWeights = false;
  String id;
  int countOfIncompleteItems = 0;
  double gradePercentAsDecimal = 0;
  //double totalPoints = 0.0;
  //double totalEarnedPoints = 0.0;
  Assessment lowest;

  String total, earned;


  Category({
    this.categoryName,
    this.categoryWeight,
    this.id,
    this.dropLowestScore,
    this.numberDropped,
    this.total,
    this.earned,
    this.equalWeights,
    this.countOfIncompleteItems,
    this.gradePercentAsDecimal,

  });


  // void delete(String itemName){
  //   categoryItems.remove(itemName);
  // }

  // void changeDropLowest(bool currentDropLowest){
  //   dropLowestScore = !currentDropLowest;
  // }
  // void addToTotalPoints(double points){
  //   totalPoints += points;
  // }
  // void resetTotolPoints(){
  //   totalPoints = 0;
  // }
  // void dropLowest() {
  //   for(Assessment a in categoryItems){
  //     a.dropped = false;
  //   }
  //   categoryItems.sort((a, b) => (a.yourPoints/a.totalPoints).compareTo(b.yourPoints/b.totalPoints));
  //   categoryItems.first.dropped = true;
  //
  // }
  String getFormattedNumber( num ) {
    //double x = ((cat.gradePercentAsDecimal / cat.categoryWeight)* 100);
    var result;
    if(num % 1 == 0) {
      result = num.toInt();
    } else {
      result = num.toStringAsFixed(2);
    }
    return result.toString();
  }

  // @override
  // String toString() {
  //   return {categoryName, categoryItems}.toString();
  // }

}