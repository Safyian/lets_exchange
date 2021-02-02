import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       Authentication().signOut();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 16.0),
          //       child: Icon(Icons.exit_to_app),
          //     ),
          //   ),
          // ],
          title: Text(
            Constant.appName,
            style: GoogleFonts.permanentMarker(fontSize: Get.width * 0.06),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  const Color(0xFF00CCFF),
                  const Color(0xFF3366FF),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          )),
      drawer: CustomDrawer(),
      body: Container(),
    );
  }
}
