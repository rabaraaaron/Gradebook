import 'package:flutter/material.dart';



class TextFieldDecoration {

  var _label;
  var _textFieldDecoration;

  TextFieldDecoration(String label) {
    _label = label;
    _textFieldDecoration = InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      labelText: _label,
      labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0
      ),
      focusColor: Colors.white,
      hoverColor: Colors.white,
    );
  }

  InputDecoration getTextFieldDecoration() {
    return _textFieldDecoration;
  }
}