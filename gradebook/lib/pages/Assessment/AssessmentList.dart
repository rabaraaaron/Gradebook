import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/pages/Assessment/AssessmentCompleted.dart';
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
              "(Dropped)",
              style: Theme.of(context).textTheme.bodyText1);
        } else{
          isDroppedText = Text("",);
        }

        String dateOrGrade;
        var totalPoints = element.getFormattedNumber(element.totalPoints);
        var yourPoints = element.getFormattedNumber(element.yourPoints);
        if(element.isCompleted){
          dateOrGrade = yourPoints + " / " + totalPoints;

        } else{
          dateOrGrade =
          DateFormat('MM-dd-yyyy').format(element.dueDate) ?? yourPoints + " / " + totalPoints;
          //DateFormat('MM-dd-yyyy').format(element.dueDate) ?? "${element.yourPoints} / ${element.totalPoints}";
          // element.dueDate,

        }
        Row r;
        if(element.isCompleted){
          r = Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10,),
              Text(
                element.name,
                style: Theme.of(context).textTheme.bodyText1,),
              SizedBox(width: 10,),
              isDroppedText,//expanded, //to display "(dropped)" if this assessment is dropped
              //Text(element.createDate.toString()),
              Expanded(child: Container(),),
              Text(
                dateOrGrade,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(width: 10, height: 60,),
            ],
          );
        } else{
          r = Row(
            children: [
              SizedBox(width: 10,),
              Text(
                element.name,
                style: Theme.of(context).textTheme.bodyText1,),
              SizedBox(width: 10,),
              isDroppedText,//expanded, //to display "(dropped)" if this assessment is dropped
              //Text(element.createDate.toString()),
              Expanded(child: Container(),),
              Text(
                dateOrGrade,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(width: 10, height: 60,),
              IconButton(
                icon: Icon(Icons.check),
                color: Colors.white,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AssessmentCompleted(
                            termID,
                            courseID,
                            categoryID,
                            element);// Here
                      });
                },
              )
            ],
          );
        }

        List<Widget> slidableActions;
        if(element.isCompleted){
          slidableActions = [
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
          ];
        } else{
          slidableActions = [
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
          ];
        }

        entries.add(Slidable(
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: .2,
          secondaryActions: slidableActions,
          child: Card(
            color: Theme.of(context).accentColor.withOpacity(.7),
            child: r,
          ),
        ));
      });

    return Column(children: entries);
  }

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
              icon: 'img',
              largeIcon: DrawableResourceAndroidBitmap('img'),
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