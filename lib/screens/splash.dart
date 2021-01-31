import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3))
        .then((value) => Get.off(LoginScreen()));
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
              child: Image.asset(Constant().logo),
            ),
          ),

          // *********** Let's Exchange Text **********
          Center(
            child: Text(
              "Let's Exchange",
              style: TextStyle(color: Colors.black, fontSize: Get.width * 0.06),
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
}
