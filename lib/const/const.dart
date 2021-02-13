import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Constant {
  static const String logo = 'assets/ex_logo.png';
  static const String prof = 'assets/prof.jpg';
  static const String appName = "Let's Exchange";
  static String userId;
  static String userName;
  static String userEmail;
  static String userImage;
}

// ********* TextField Input Decoration Constant **********
InputDecoration inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  hintText: 'xyz@abc.com',
  hintStyle: TextStyle(color: Colors.grey),
  labelText: 'Email',
  prefixIcon: Icon(Icons.email),
);

// ******** Gradient Color *********
BoxDecoration customDecoration = BoxDecoration(
  gradient: new LinearGradient(
    colors: [
      const Color(0xFF00CCFF),
      const Color(0xFF3366FF),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  ),
);
