import 'dart:ui';
import 'package:flutter/material.dart';

class ContainerStyles {
  static BoxDecoration getColoredBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xff1f005c),
          Color(0xff5b0060),
          Color(0xff870160),
        ], // Gradient from https://learnui.design/tools/gradient-generator.html
        tileMode: TileMode.mirror,
      ),
    );
  }

  static BoxDecoration roundetCorners(
      {Color color = const Color.fromARGB(255, 8, 173, 11)}) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: color,
    );
  }

  static BoxDecoration getBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]
        /*
      border: Border.all(
          color: Color.fromARGB(118, 0, 0, 0),
          width: 1.0,
          style: BorderStyle.solid),*/
        );
  }

  static TextStyle getTextStyle() {
    return const TextStyle(
      color: Color.fromARGB(255, 196, 196, 196),
    );
  }

  static EdgeInsets getPadding() {
    return const EdgeInsets.fromLTRB(0, 10, 0, 25);
  }

  static EdgeInsets getMargin() {
    return const EdgeInsets.all(15.0);
  }

  static getInputStyle(String labelTextInput) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      labelText: labelTextInput,
    );
  }
}
