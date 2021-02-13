import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            Constant.appName,
            style: GoogleFonts.permanentMarker(fontSize: Get.width * 0.06),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: customDecoration,
          )),
      drawer: CustomDrawer(),
      body: Container(),
    );
  }

  getUserInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .get()
        .then((value) {
      print('value = ${value.data()['image']}');

      Constant.userEmail = value.data()['email'];
      Constant.userName = value.data()['name'];
      Constant.userImage = value.data()['image'];
    });
  }
}
