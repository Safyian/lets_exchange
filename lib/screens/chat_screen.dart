import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/chat_model.dart';
import 'package:lets_exchange/model/product_model.dart';

class ChatScreen extends StatefulWidget {
  String Name;
  String uid;

  ChatScreen({this.Name, this.uid});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var chatController;
  List<ChatModel> _chatList = [];

  @override
  void initState() {
    chatController = TextEditingController();
    listentoChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _chatList.sort((a, b) => a.time.compareTo(b.time));
    //

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
            widget.Name,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Constant.iconColor,
                fontSize: Get.width * 0.05),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      //
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: Get.height * 0.08),
              child: ListView.builder(
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    return msgContainer(
                        msg: _chatList[index].message,
                        uid: _chatList[index].sendBy);
                  }),
            ),

            // Type message textfield
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Get.width,
                // height: Get.height * 0.08,
                // color: Constant.primary,
                child: TextFormField(
                  controller: chatController,
                  style: TextStyle(fontSize: Get.width * 0.04),
                  decoration: inputDecoration.copyWith(
                    // prefixIcon: Icon(
                    //   Icons.search,
                    //   color: Constant.btnWidgetColor,
                    // ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        await sendMessage();
                        chatController.clear();
                      },
                      child: Icon(
                        Icons.send,
                        color: Constant.btnWidgetColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: 'Type here ...',
                  ),
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // send message method
  sendMessage() async {
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(Constant.userId)
        .collection('messages')
        .doc(widget.uid)
        .set({'id': widget.uid});
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(Constant.userId)
        .collection('messages')
        .doc(widget.uid)
        .collection('chating')
        .add({
      'message': chatController.text.toString(),
      'sendTo': widget.uid,
      'sendBy': Constant.userId,
      'time': DateTime.now(),
    });
    ////
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.uid)
        .collection('messages')
        .doc(Constant.userId)
        .set({'id': Constant.userId});
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.uid)
        .collection('messages')
        .doc(Constant.userId)
        .collection('chating')
        .add({
      'message': chatController.text.toString(),
      'sendTo': widget.uid,
      'sendBy': Constant.userId,
      'time': DateTime.now(),
    });
  }

  // get messages
  listentoChat() {
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(Constant.userId)
        .collection('messages')
        .doc(widget.uid)
        .collection('chating')
        .snapshots()
        .listen((event) {
      if (event.docs != null) {
        print('bet === ${event.docs}');
        _chatList.clear();
        event.docs.forEach((element) {
          _chatList.add(ChatModel.fromMap(element.data()));
        });
        setState(() {});
      }
    });
  }

  // msg Container
  Widget msgContainer({@required String msg, @required String uid}) {
    return msg.contains('https:')
        ? Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Align(
                alignment: uid == Constant.userId
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Container(
                    // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    width: Get.width * 0.7,
                    height: Get.height * 0.5,
                    // constraints: BoxConstraints(
                    //     maxWidth: Get.width * 0.7, maxHeight: Get.height * 0.5),
                    decoration: BoxDecoration(
                        // color: Constant.primary,
                        borderRadius: BorderRadius.only(
                            topRight: uid == Constant.userId
                                ? Radius.circular(0)
                                : Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomLeft: uid == Constant.userId
                                ? Radius.circular(12)
                                : Radius.circular(0),
                            bottomRight: Radius.circular(12))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: uid == Constant.userId
                              ? Radius.circular(0)
                              : Radius.circular(12),
                          topLeft: Radius.circular(12),
                          bottomLeft: uid == Constant.userId
                              ? Radius.circular(12)
                              : Radius.circular(0),
                          bottomRight: Radius.circular(12)),
                      child: Image.network(
                        msg,
                        fit: BoxFit.cover,
                      ),
                    ))),
          )
        : Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Align(
              alignment: uid == Constant.userId
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                  decoration: BoxDecoration(
                      color: Constant.primary,
                      borderRadius: BorderRadius.only(
                          topRight: uid == Constant.userId
                              ? Radius.circular(0)
                              : Radius.circular(12),
                          topLeft: Radius.circular(12),
                          bottomLeft: uid == Constant.userId
                              ? Radius.circular(12)
                              : Radius.circular(0),
                          bottomRight: Radius.circular(12))),
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: Get.width * 0.04),
                    // textAlign: TextAlign.center,
                  )),
            ),
          );
  }
}
