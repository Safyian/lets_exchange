import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/add_product.dart';
import 'package:lets_exchange/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: AppBar(
          elevation: 0.0,
          leading: Container(),
          flexibleSpace: Container(
            color: Constant.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: <Widget>[
                      //
                      //
                      //********* Drawer Menu  **********
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState.openDrawer(),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Constant.iconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      Spacer(),
                      //
                      //********* Notifications Icon *******/
                      Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.06),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            FontAwesome5.bell,
                            color: Constant.iconColor,
                            size: 28,
                          ),
                        ),
                      ),

                      //
                      // *********** Search Icons *********
                      Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.06),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Ionicons.md_search,
                            color: Constant.iconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      //
                      // ********* POST Button *********
                      GestureDetector(
                        onTap: () {
                          Get.to(AddProduct());
                        },
                        child: Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Constant.btnColor,
                          ),
                          child: Center(
                            child: Text(
                              'POST',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Constant.background,
      body: Container(
        color: Constant.background,
      ),
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
