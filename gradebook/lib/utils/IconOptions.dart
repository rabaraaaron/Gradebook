import 'package:flutter/material.dart';
import 'package:gradebook/services/course_service.dart';

class IconOptions{
  
  Map<String, IconButton> iconButtonMap;
  Map<String, Icon> iconMap;
  CourseService courseService;
  String courseID;

  
  IconOptions(String termID, String cID){

    courseService = CourseService(termID);
    this.courseID = cID;

    double iconSize = 40;

    iconButtonMap = {

      'math': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.functions),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'math');
        },
      ),
      'computer': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.laptop_chromebook),
        onPressed: () {
          courseService.updateCourseIcon(courseID, 'computer');
        },
      ),

      'globe': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.public),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'globe');
        },
      ),

      'music': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.music_note),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'music');
        },
      ),

      'camera': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.photo_camera),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'camera');
        },
      ),

      'science': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.science),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'science');
        },
      ),


      'pe': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.sports),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'pe');
        },
      ),


      'reading': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.menu_book_outlined),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'reading');
        },
      ),

      'law': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.gavel),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'law');
        },
      ),

      'culinary': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.restaurant_menu),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'culinary');
        },
      ),

      'yoga': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.self_improvement),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'yoga');
        },
      ),

      'speaking': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.mic_outlined),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'speaking');
        },
      ),

      'economics': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.show_chart),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'economics');
        },
      ),

      'astronomy': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.star),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'astronomy');
        },
      ),

      'theater': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.theater_comedy),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'theater');
        },
      ),

      'eco': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.eco),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'eco');
        },
      ),

      'design': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.design_services),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'design');
        },
      ),

      'virus': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.coronavirus),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'virus');
        },
      ),

      'engineering': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.engineering),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'engineering');
        },
      ),

      'airplane': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.airplanemode_active),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'airplane');
        },
      ),

      'electric': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.electrical_services),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'electric');
        },
      ),

      'lifting': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.fitness_center),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'lifting');
        },
      ),

      'writing': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.format_align_left),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'writing');
        },
      ),

      'history': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.history_edu),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'history');
        },
      ),

      'language': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.g_translate),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'language');
        },
      ),

      'medical': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.medical_services),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'medical');
        },
      ),

      'military': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.military_tech),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'military');
        },
      ),

      'movie': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.movie),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'movie');
        },
      ),

      'art': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.palette),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'art');
        },
      ),

      'architecture': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.architecture),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'architecture');
        },
      ),

      'campaign': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.campaign),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'campaign');
        },
      ),

      'carpenter': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.carpenter),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'carpenter');
        },
      ),

      'business': IconButton(
        iconSize: iconSize,
        icon: Icon(Icons.business_center),
        onPressed: (){
          courseService.updateCourseIcon(courseID, 'business');
        },
      ),

    };


    iconMap = {
      'default': Icon(Icons.touch_app),
      'math': Icon(Icons.functions),
      'computer': Icon(Icons.laptop_chromebook),
      'globe': Icon(Icons.public),
      'music': Icon(Icons.music_note),
      'camera': Icon(Icons.photo_camera),
      'science': Icon(Icons.science),
      'pe': Icon(Icons.sports),
      'reading': Icon(Icons.menu_book_outlined),
      'law': Icon(Icons.gavel),
      'culinary': Icon(Icons.restaurant_menu),
      'yoga': Icon(Icons.self_improvement),
      'speaking': Icon(Icons.mic_outlined),
      'economics': Icon(Icons.show_chart),
      'astronomy': Icon(Icons.star),
      'theater': Icon(Icons.theater_comedy),
      'eco': Icon(Icons.eco),
      'design': Icon(Icons.design_services),
      'virus': Icon(Icons.coronavirus),
      'engineering': Icon(Icons.engineering),
      'airplane': Icon(Icons.airplanemode_active),
      'electric': Icon(Icons.electrical_services),
      'lifting': Icon(Icons.fitness_center),
      'writing': Icon(Icons.format_align_left),
      'history': Icon(Icons.history_edu),
      'language': Icon(Icons.g_translate),
      'medical': Icon(Icons.medical_services),
      'military': Icon(Icons.military_tech),
      'movie': Icon(Icons.movie),
      'art': Icon(Icons.palette),
      'architecture': Icon(Icons.architecture),
      'campaign': Icon(Icons.campaign),
      'carpenter': Icon(Icons.carpenter),
      'business': Icon(Icons.business_center),


    };
  }

  List<IconButton> getAllIcons(){
    return iconButtonMap.values.toList();
  }

  Icon getIconFromString(String iconName){
    return iconMap[iconName];
  }

}