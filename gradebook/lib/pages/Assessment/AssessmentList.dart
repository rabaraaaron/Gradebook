import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/pages/Assessment/AssessmentOptions.dart';
import 'package:gradebook/pages/Assessment/ReminderConfirmation.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AssessmentList extends StatefulWidget {
  String termID, courseID, categoryID, courseName;

  AssessmentList({Key key, this.termID, this.courseID, this.categoryID, this.courseName})
      : super(key: key);
  @override
  _AssessmentListState createState() => _AssessmentListState(
    termID: this.termID,
    courseID: this.courseID,
    categoryID: this.categoryID,
    // courseName: this.courseName,
  );
}
class _AssessmentListState extends State<AssessmentList> {

  String termID, courseID, categoryID;
  final SlidableController slidableController = new SlidableController();
  _AssessmentListState({this.termID, this.courseID, this.categoryID});



  @override
  Widget build(BuildContext context) {
    AssessmentService assServ = new AssessmentService(termID, courseID, categoryID);
    final assessments = Provider.of<List<Assessment>>(context);
    Text isDroppedText;
    List<Widget> entries = [];
    if (assessments != null)
      assessments.forEach((element) {

        if(element.isDropped == true){
          isDroppedText = Text(
              "<-- Dropped",
              style: Theme.of(context).textTheme.bodyText2);
        } else{
          isDroppedText = Text("",);
        }

        String dateOrGrade;
        if(element.isCompleted){
          dateOrGrade = "${element.yourPoints} / ${element.totalPoints}";

        } else{
          //TODO: display due date instead of grade if assessment is not completed
          //todo: what if the due date is not entered? ------(by Mohammad)
          dateOrGrade =
          DateFormat('yyyy-MM-dd').format(element.dueDate) ?? "${element.yourPoints} / ${element.totalPoints}";
          // element.dueDate,

        }

        entries.add(Slidable(
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: .2,
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Colors.transparent,
              closeOnTap: true,
              iconWidget: Icon(
                Icons.add_alert,
                color: Theme.of(context).dividerColor,
                size: 35,
              ),
              onTap: () => scheduleNotification(courseID, element.name),
            ),
            IconSlideAction(
              color: Colors.transparent,
              closeOnTap: true,
              iconWidget: Icon(
                Icons.settings,
                color: Theme.of(context).dividerColor,
                size: 35,
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AssessmentOptions(context, termID,
                          courseID, categoryID, element);
                    });
              },
            ),
            IconSlideAction(
              color: Colors.transparent,
              closeOnTap: true,
              iconWidget: Icon(
                Icons.delete,
                color: Theme.of(context).dividerColor,
                size: 35,
              ),
              onTap: ()async {
                await assServ.deleteAssessment(element.id);
              },
            )
          ],
          child: Card(
            color: Theme.of(context).accentColor.withOpacity(.2),

            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                Text(
                  element.name,
                  style: Theme.of(context).textTheme.bodyText2,),
                SizedBox(width: 10,),
                isDroppedText,//expanded, //to display "(dropped)" if this assessment is dropped
                //Text(element.createDate.toString()),
                Expanded(child: Container(),),
                Text(
                  dateOrGrade,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(width: 10, height: 60,)
              ],
            ),
          ),
        ));
      });

    return Column(children: entries);
  }


// class _AssessmentListState extends State<AssessmentList> {
//
//
//   String termID, courseID, categoryID, courseName;
//
//
//
//   final SlidableController slidableController = new SlidableController();
//   _AssessmentListState({this.termID, this.categoryID, this.courseID, this.courseName});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     AssessmentService assServ = new AssessmentService(termID, courseID, categoryID);
//    List assessments = Provider.of<List<Assessment>>(context);
//     List<Widget> entries = [];
//     if (Provider.of<List<Assessment>>(context) != null)  {
//       assessments.forEach((element) {
//         print(element);
//         entries.add(
//             Slidable(
//               controller: slidableController,
//               actionPane: SlidableDrawerActionPane(),
//               actionExtentRatio: .2,
//               secondaryActions: <Widget>[
//                 IconSlideAction(
//                   color: Colors.transparent,
//                   closeOnTap: true,
//                   iconWidget: Icon(
//                     Icons.add_alert,
//                     color: Theme.of(context).dividerColor,
//                     size: 35,
//                   ),
//                   onTap: () => scheduleNotification(courseName, element.name),
//                 ),
//                 IconSlideAction(
//                   color: Colors.transparent,
//                   closeOnTap: true,
//                   iconWidget: Icon(
//                     Icons.delete,
//                     color: Theme.of(context).dividerColor,
//                     size: 35,
//                   ),
//                   onTap: () async {
//
//                     await assServ.deleteAssessment(element.id);
//                   },
//                 )
//               ],
//               child: Row(
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(width: 10,),
//                   Expanded(
//                       flex: 8,
//                       child: TextFormField(
//                         initialValue: element.name,
//                         style: Theme.of(context).textTheme.headline5,
//                         inputFormatters: [LengthLimitingTextInputFormatter(20)],
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                         ),
//                         onFieldSubmitted: (itemName) {
//                           print(itemName);
//                         },
//                       )
//                   ),
//                   Expanded(
//                     flex: 4,
//                     child: Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               initialValue: "${element.yourPoints}",
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(4)
//                               ],
//                               style: Theme.of(context).textTheme.headline5,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   signed: true, decimal: true),
//                               onFieldSubmitted: (yourScore) {
//                                 if (double.tryParse(yourScore) != null) {
//                                   print("Good change");
//                                 }
//                                 setState(() {
//                                   //This is so that incorrect inputs that are not
//                                   //pushed to the server will revert to the previous
//                                   //version
//                                 });
//                                 print(yourScore);
//                               },
//                             ),
//                           ),
//                           Text("/ ", style: Theme.of(context).textTheme.headline5,),
//                           Expanded(
//                             child: TextFormField(
//                               initialValue: "${element.totalPoints}",
//                               inputFormatters: [LengthLimitingTextInputFormatter(4)],
//                               style: Theme.of(context).textTheme.headline5,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   signed: true, decimal: true),
//                               onFieldSubmitted: (totalPoints) {
//                                 if (double.tryParse(totalPoints) != null) {
//                                   print("Good change");
//                                 }
//                                 setState(() {
//                                   //This is so that incorrect inputs that are not
//                                   //pushed to the server will revert to the previous
//                                   //version
//                                 });
//                               },
//                             ),
//                           )
//                         ]
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       });
//     }
//
//     return Column(children: entries);



  Future scheduleNotification(String courseID, String assignmentName) async {

    print('local notification scheduler reached' + courseID.toString());
    tz.initializeTimeZones();


    DateTime d;
    TextStyle cancelAndDone = TextStyle(
        fontSize: 25.0,
        color: Colors.white,
        fontFamily: GoogleFonts.quicksand().toStringShort(),
        fontWeight: FontWeight.w300);
    TextStyle itemStyle = TextStyle(
        fontSize: 25.0,
        fontFamily: GoogleFonts.quicksand().toStringShort(),
        color: Colors.black,
        fontWeight: FontWeight.w400);

    DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute + 1,
        ),
        theme: DatePickerTheme(
          headerColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          cancelStyle: cancelAndDone,
          doneStyle: cancelAndDone,
          itemStyle: itemStyle,
        ),
        onConfirm: (date) async {
          d = date;

          var scheduleNotificationDateTime =
          tz.TZDateTime.from(d, tz.local);

          var androidDetails = AndroidNotificationDetails(
              'channelID',
              'Local Notifications',
              'Scheduled alarm notification',
              icon: 'icon',
              largeIcon: DrawableResourceAndroidBitmap('icon'),
              importance: Importance.high
          );

          var iOSDetails = IOSNotificationDetails();

          var generalNotificationDetails = NotificationDetails(
            android: androidDetails,
            iOS: iOSDetails,
          );


          String message1stHalf = 'Do ' + assignmentName + 'from ' + courseID;
          //TODO: Get the name of the course

          if(!d.toLocal().isBefore(DateTime.now())){

            await localNotification.zonedSchedule(
                0,
                'Assignment Reminder',
                message1stHalf,
                scheduleNotificationDateTime,
                generalNotificationDetails,
                uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
                androidAllowWhileIdle: true);
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ReminderConfirmation(assignmentName, d);
            },
          );
        }
    );
  }
}