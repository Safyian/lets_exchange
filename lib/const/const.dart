import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Constant {
  static const String logo = 'assets/ex_logo.png';
  static const String prof = 'assets/prof.jpg';
  static const String appName = "let's Exchange";

  static const Color primary = Color(0XFFE8F1FF);
  static const Color background = Color(0XFFF6F8FF);
  static const Color iconColor = Color(0XFF333C54);
  static const Color btnColor = Color(0XFF0DC98D);
  static const Color btnWidgetColor = Color(0XFF5C80B8);
  static const Color drawerBtnColor = Color(0XFF073CAB);
  static String userId;
  static String userName;
  static String userEmail;
  static String userImage;
}

// ********* TextField Input Decoration Constant **********
InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.0,
      )),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.0,
      )),
  // hintText: 'xyz@abc.com',
  hintStyle: TextStyle(color: Colors.black54),
  // labelText: 'Email',
  labelStyle: TextStyle(color: Colors.black54),
  // prefixIcon: Icon(
  //   Icons.email,
  //   color: Constant.primary
  // ),
);

// ******** Gradient Color *********
BoxDecoration customDecoration = BoxDecoration(
  gradient: new LinearGradient(
    colors: [
      // const Color(0xFF00CCFF),
      // const Color(0xFF3366FF),
      Constant.primary,
      Constant.background,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
BoxDecoration customDecoration2 = BoxDecoration(
  gradient: new LinearGradient(
    colors: [
      const Color(0xFF8e9eab),
      const Color(0xFFeef2f3),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  ),
);
