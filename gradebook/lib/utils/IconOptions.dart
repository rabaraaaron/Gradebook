import 'package:flutter/material.dart';

class IconOptions{
  Icon getIconFromString(String iconName){
    switch (iconName){
      case 'computer':{
        return Icon(Icons.computer);
      } break;
      case 'globe':{
        return Icon(Icons.public);
      } break;
      case 'music':{
        return Icon(Icons.music_note);
      } break;
      case 'camera':{
        return Icon(Icons.photo_camera);
      } break;
      case 'science':{
        return Icon(Icons.science);
      } break;
      case 'pe':{
        return Icon(Icons.sports_basketball);
      } break;
    }
  }

}