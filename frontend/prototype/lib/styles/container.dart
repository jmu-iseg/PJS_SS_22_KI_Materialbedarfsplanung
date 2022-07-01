import 'dart:ui';
import 'package:flutter/material.dart';

class ContainerStyles {
  static BoxDecoration getBoxDecoration() {
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

  static TextStyle getTextStyle() {
    return const TextStyle(
      color: Colors.white,
    );
  }

  static EdgeInsets getPadding() {
    return const EdgeInsets.fromLTRB(0, 10, 0, 25);
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