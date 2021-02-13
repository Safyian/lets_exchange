import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/home_screen.dart';
import 'package:lets_exchange/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) => checkUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ******* Logo ********
          Center(
            child: Container(
              width: Get.width * 0.35,
              height: Get.width * 0.35,
              child: Image.asset(Constant.logo),
            ),
          ),

          // *********** Let's Exchange Text **********
          Center(
            child: Text(
              "Let's Exchange",
              style: GoogleFonts.permanentMarker(
                // color: Colors.white,
                fontSize: Get.width * 0.06,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.0
                  ..color = Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.1,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  checkUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // ****** Storing user Info ******
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        print('value = ${value.data()['image']}');
        Constant.userId = value.data()['uid'];
        Constant.userEmail = value.data()['email'];
        Constant.userName = value.data()['name'];
        Constant.userImage = value.data()['image'];
      });
      Get.off(HomeScreen());
    } else
      Get.off(LoginScreen());
  }
}
