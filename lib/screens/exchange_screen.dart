import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/exchange_model.dart';
import 'package:lets_exchange/screens/chat_screen.dart';
import 'package:http/http.dart' as http;

class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<ExchangeModel> _myExchanges = [];
  @override
  void initState() {
    getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _myExchanges.sort((a, b) => a.time.compareTo(b.time));
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
            'Exchange',
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
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: ListView.builder(
            itemCount: _myExchanges.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Request From: ${_myExchanges[index].buyerName}',
                        style: TextStyle(
                            color: _myExchanges[index].status == 'sold'
                                ? Colors.grey[350]
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.042),
                      ),
                      SizedBox(height: Get.width * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width * 0.4,
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width * 0.2,
                                  height: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            _myExchanges[index].productImg),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(height: Get.width * 0.02),
                                Container(
                                  width: Get.width * 0.4,
                                  alignment: Alignment.center,
                                  child: Text(
                                    _myExchanges[index].productName,
                                    style: TextStyle(
                                        color:
                                            _myExchanges[index].status == 'sold'
                                                ? Colors.grey[350]
                                                : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Get.width * 0.04),
                                  ),
                                ),
                                SizedBox(height: Get.width * 0.02),
                                Container(
                                  width: Get.width * 0.4,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Rs.${_myExchanges[index].productPrice.toInt()}',
                                    style: TextStyle(
                                        color:
                                            _myExchanges[index].status == 'sold'
                                                ? Colors.grey[350]
                                                : Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Get.width * 0.04),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Get.width * 0.02),
                          Container(
                              height: Get.width * 0.2,
                              child: Icon(Icons.autorenew)),
                          SizedBox(width: Get.width * 0.02),
                          Container(
                            width: Get.width * 0.4,
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width * 0.2,
                                  height: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(_myExchanges[index]
                                            .exchangeProductImg),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(height: Get.width * 0.02),
                                Container(
                                  width: Get.width * 0.4,
                                  alignment: Alignment.center,
                                  child: Text(
                                    _myExchanges[index].exchangeProductName,
                                    style: TextStyle(
                                        color:
                                            _myExchanges[index].status == 'sold'
                                                ? Colors.grey[350]
                                                : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Get.width * 0.04),
                                  ),
                                ),
                                SizedBox(height: Get.width * 0.02),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: Get.height * 0.04,
                                    maxWidth: Get.width * 0.4,
                                  ),
                                  // alignment: Alignment.center,
                                  child: Text(
                                    _myExchanges[index].exchangeProductDetails,
                                    style: TextStyle(
                                        color:
                                            _myExchanges[index].status == 'sold'
                                                ? Colors.grey[350]
                                                : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Get.width * 0.038),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.width * 0.025),

                      // Sell or Cancel Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width * 0.2,
                            child: ElevatedButton(
                              onPressed: _myExchanges[index].status == 'sold'
                                  ? null
                                  : () {
                                      exchangeDeal(
                                          reqUid: _myExchanges[index].reqUid,
                                          prodUid:
                                              _myExchanges[index].productUid,
                                          quantity:
                                              _myExchanges[index].quantity);
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Constant.btnWidgetColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Deal',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.02),
                          Container(
                            // width: Get.width * 0.2,
                            child: ElevatedButton(
                              onPressed: _myExchanges[index].status == 'sold'
                                  ? null
                                  : () {
                                      cancelDeal(
                                        reqUid: _myExchanges[index].reqUid,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Constant.btnWidgetColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.02),
                          Container(
                            width: Get.width * 0.2,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(ChatScreen(
                                    Name: _myExchanges[index].buyerName,
                                    uid: _myExchanges[index].buyerUid));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Constant.btnWidgetColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Chat',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  // getting orders list
  getRequests() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('ExchangeRequests')
        .where('status', isNotEqualTo: 'cancel')
        .snapshots()
        .listen((event) {
      if (event.docs != null) {
        _myExchanges.clear();

        event.docs.forEach((element) {
          _myExchanges.add(ExchangeModel.fromMap(element.data()));
        });
        setState(() {});
      }
    });
  }

  // sell product
  exchangeDeal(
      {@required String reqUid,
      @required String prodUid,
      @required int quantity}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('ExchangeRequests')
        .doc(reqUid)
        .update({'status': 'sold'});
    if (quantity > 1) {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(prodUid)
          .update({'prodQuantity': quantity - 1});
    } else if (quantity == 1) {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(prodUid)
          .update({'prodStatus': 'sold', 'prodQuantity': 0});
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('ExchangeRequests')
        .where('productUid', isEqualTo: prodUid)
        .where('reqUid', isNotEqualTo: reqUid)
        .snapshots()
        .listen((event) {
      event.docs.forEach((value) async {
        print('value === ${value.id}');
        if (quantity == 1) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Constant.userId)
              .collection('ExchangeRequests')
              .doc(value.id)
              .update({'status': 'cancel'});
        }
      });
    });
    _createNotification(
        uid: reqUid,
        heading: 'Exchange Request Accepted',
        content: '${Constant.userName} accepted your Exchange Request');
  }

  // cancel deal
  cancelDeal({
    @required String reqUid,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('ExchangeRequests')
        .doc(reqUid)
        .update({'status': 'cancel'});
  }

  // push notification
  _createNotification({String heading, String uid, String content}) async {
    var res = await http.post(
      'https://onesignal.com/api/v1/notifications',
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization":
            "Basic ZGM1MzU4YzgtNzIyNi00ZDA5LThiYzUtNDNmMzYyM2YxYTYy"
      },
      body: json.encode({
        'app_id': "23ef2e1f-3ed9-474f-9975-d56982cbc641",
        'headings': {"en": heading},
        'contents': {"en": content},
        // 'contents': {"en": 'I need a Drink'},
        'included_segments': ["Subscribed Users"],
        "filters": [
          {"field": "tag", "key": 'uid', "relation": "=", "value": "$uid"},
          {"field": "tag", "key": 'push', "relation": "=", "value": "yes"}
        ],
      }),
    );
  }
}
