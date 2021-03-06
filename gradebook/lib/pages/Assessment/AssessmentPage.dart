import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/pages/Assessment/NewAssessment.dart';
import 'package:provider/provider.dart';
import '../../model/Category.dart';
import 'AssessmentList.dart';

// ignore: must_be_immutable
class AssessmentPage extends StatefulWidget {
  String termID;
  String courseID;
  String courseName;
  int index;

  AssessmentPage({this.termID, this.courseID, this.index, this.courseName});

  @override
  _AssessmentPageState createState() =>
      _AssessmentPageState(termID, courseID, index, courseName);
}

class _AssessmentPageState extends State<AssessmentPage> {
  String termID;
  String courseID;
  int index;
  String courseName;

  _AssessmentPageState(String tID, String cID, int index, String courseN) {
    this.termID = tID;
    this.courseID = cID;
    this.index = index;
    this.courseName = courseN;
  }

  @override
  Widget build(BuildContext context) {
    Category cat = Provider.of<List<Category>>(context)[index];
    //AssessmentService assServ = new AssessmentService(termID, courseID, cat.id);
    //final name = TextEditingController();
    //final assessments = Provider.of<List<Assessment>>(context);
    // double totalPoints = cat.total;
    // double yourPoints = cat.earned;

    //var categoryList = Provider.of<List<Category>>(context);
    //Category catFromProvider;
    // for(Category category in categoryList){
    //   if (category.id == cat.id){
    //     catFromProvider = category;
    //   }
    // }


    //cat.isManuallyEntered = true;

    var textForManuallySet = Row();
    if(cat.isManuallySet) {
      textForManuallySet = Row(
        children: [
          Icon(Icons.lock_outline_sharp, size: 22,),
          Text(" Manually Set",
            style: Theme
                .of(context)
                .textTheme
                .bodyText2,
            textScaleFactor: 0.8,
          ),
        ],
      );
    }

    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Text(
                    "${cat.categoryName}",
                    style: Theme.of(context).textTheme.headline5,
                    textScaleFactor: 1.3,
                  ),
                  textForManuallySet,
                ],
              ),
            ),
            //SizedBox(width: 20,),
            Text(cat.getFormattedNumber(cat.categoryWeight)+"%",
              style: Theme.of(context).textTheme.headline5,
              textScaleFactor: 1.2,
            ),
          ],
        ),
        children: [
          Center(
            child: Row(
              children: [
                Expanded(child: Container(),flex: 3,),
                getCatGrade(cat),
                Expanded(child: Container(),flex: 2,),
                Container(
                  width: 60,
                  child: RaisedButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Theme.of(context).accentColor, width: 2)
                    ),
                    color: Colors.transparent,
                    child: Icon(Icons.add, color: Theme.of(context).accentColor, size: 30, ),
                    //Text("Add Assessment", style: Theme.of(context).textTheme.headline2,),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return   AssessmentPopUp(context, termID, courseID, cat.id);}
                      );
                      setState(() { });
                    },
                  ),
                ),
                SizedBox(width: 5,),
              ],
            ),
          ),

          AssessmentList(
            termID: termID,
            courseID: courseID,
            categoryID: cat.id,
            courseName: courseName,
          )
        ],
      ),
    );
  }

  Widget getCatGrade(Category cat) {

    if(cat.equalWeights){
      double x = ((cat.gradePercentAsDecimal / cat.categoryWeight)* 100);
      var result;
      if(x % 1 == 0) {
        result = x.toInt();
      } else {
        result = ((cat.gradePercentAsDecimal / cat.categoryWeight) * 100)
            .toStringAsFixed(2);
      }
      return Text('Grade: ' + result.toString() + "%",
        // Text( num.parse(((cat.gradePercentAsDecimal / cat.categoryWeight)* 100).toStringAsFixed(2)).toString(),
        style: Theme.of(context).textTheme.headline5,
      );

    } else {
      var result;
      if(double.parse(cat.total) > 0) {
        result = cat.getFormattedNumber(
            (double.parse(cat.earned) / double.parse(cat.total)) * 100);
      } else {
        result = cat.getFormattedNumber(0);
      }

      return Text('Grade: ' + result.toString() + "%",
          style: Theme.of(context).textTheme.headline5,
        );
      //   Text(
      //   "${cat.earned}" + "/" + "${cat.total}",
      //   style: Theme.of(context).textTheme.headline4,
      // );
    }
  }

}