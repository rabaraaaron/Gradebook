import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/pages/Assessment/NewAssessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:provider/provider.dart';
import '../../model/Category.dart';
import 'AssessmentList.dart';

// ignore: must_be_immutable
class AssessmentTile extends StatefulWidget {
  String termID;
  String courseID;
  String courseName;
  int index;

  AssessmentTile({this.termID, this.courseID, this.index, this.courseName});

  @override
  _AssessmentTileState createState() =>
      _AssessmentTileState(termID, courseID, index, courseName);
}

class _AssessmentTileState extends State<AssessmentTile> {
  String termID;
  String courseID;
  int index;
  String courseName;

  _AssessmentTileState(String tID, String cID, int index, String courseN) {
    this.termID = tID;
    this.courseID = cID;
    this.index = index;
    this.courseName = courseN;
  }

  @override
  Widget build(BuildContext context) {
    Category cat = Provider.of<List<Category>>(context)[index];
    AssessmentService assServ = new AssessmentService(termID, courseID, cat.id);
    final name = TextEditingController();
    final assessments = Provider.of<List<Assessment>>(context);
    // double totalPoints = cat.total;
    // double yourPoints = cat.earned;

    var categoryList = Provider.of<List<Category>>(context);
    Category catFromProvider;
    for(Category category in categoryList){
      if (category.id == cat.id){
        catFromProvider = category;
      }
    }
    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${cat.categoryName}",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            //SizedBox(width: 20,),
            Text(
              "${cat.categoryWeight}%",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        children: [
          Center(
            child: Text(
              "${cat.earned}" + "/" + "${cat.total}",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
              color: Theme.of(context).primaryColor,
              child: Text("Add Assessment", style: Theme.of(context).textTheme.headline2,),
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
}