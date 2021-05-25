import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/userModel.dart';
import 'package:lets_exchange/screens/chat_screen.dart';

class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  List<UserModel> _userList = [];
  @override
  void initState() {
    getMyChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      // ********** AppBar ********
      appBar: AppBar(
        backgroundColor: Constant.primary,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Constant.iconColor,
            size: 28,
          ),
        ),
        title: Container(
          width: Get.width * 0.8,
          child: Text(
            'My Chats',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Constant.iconColor,
                fontSize: Get.width * 0.05),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      //
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: _userList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(ChatScreen(
                      uid: _userList[index].uid, Name: _userList[index].name));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    // height: Get.height * 0.15,
                    padding: const EdgeInsets.all(8.0),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Get.width * 0.075,
                          backgroundImage: NetworkImage(_userList[index].image),
                        ),
                        SizedBox(width: Get.width * 0.02),
                        Text(
                          _userList[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Get.width * 0.045),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  //
  // get chats methods
  getMyChats() {
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(Constant.userId)
        .collection('messages')
        .get()
        .then((value) {
      print('bet == ${value.docs}');

      _userList.clear();
      value.docs.forEach((element) {
        print('bet 2== ${element.id}');
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          _userList.add(UserModel.fromMap(value.data()));
          setState(() {});
        });
      });
    });
  }
}
