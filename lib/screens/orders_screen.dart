import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/order_model.dart';
import 'package:lets_exchange/screens/chat_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderModel> _myOrders = [];
  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _myOrders.sort((a, b) => a.time.compareTo(b.time));
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
            'Orders',
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
            itemCount: _myOrders.length,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.2,
                        height: Get.width * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_myOrders[index].productImg),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width * 0.5,
                            child: Text(
                              _myOrders[index].productName,
                              style: TextStyle(
                                  color: _myOrders[index].status == 'sold'
                                      ? Colors.grey[350]
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Get.width * 0.04),
                            ),
                          ),
                          Text(
                            'Rs. ${_myOrders[index].productPrice}',
                            style: TextStyle(
                                color: _myOrders[index].status == 'sold'
                                    ? Colors.grey[350]
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: Get.width * 0.04),
                          ),
                          Text(
                            'Stock: ${_myOrders[index].quantity} remaining',
                            style: TextStyle(
                                color: _myOrders[index].status == 'sold'
                                    ? Colors.grey[350]
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: Get.width * 0.04),
                          ),
                          Container(
                            width: Get.width * 0.55,
                            child: Text(
                              'Request From: ${_myOrders[index].buyerName}',
                              style: TextStyle(
                                  color: _myOrders[index].status == 'sold'
                                      ? Colors.grey[350]
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Get.width * 0.04),
                            ),
                          ),
                          SizedBox(height: Get.width * 0.025),

                          // Sell or Cancel Button
                          Row(
                            children: [
                              Container(
                                width: Get.width * 0.2,
                                child: ElevatedButton(
                                  onPressed: _myOrders[index].status == 'sold'
                                      ? null
                                      : () {
                                          sellProduct(
                                              reqUid: _myOrders[index].reqUid,
                                              prodUid:
                                                  _myOrders[index].productUid,
                                              quantity:
                                                  _myOrders[index].quantity);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    primary: Constant.btnWidgetColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Sell',
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
                                  onPressed: _myOrders[index].status == 'sold'
                                      ? null
                                      : () {
                                          // Get.back();
                                          cancelRequest(
                                              reqUid: _myOrders[index].reqUid);
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
                                        Name: _myOrders[index].buyerName,
                                        uid: _myOrders[index].buyerUid));
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
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  // getting orders list
  getOrders() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('BuyerRequests')
        .where('status', isNotEqualTo: 'cancel')
        .snapshots()
        .listen((event) {
      if (event.docs != null) {
        _myOrders.clear();
        event.docs.forEach((element) {
          _myOrders.add(OrderModel.fromMap(element.data()));
        });
        setState(() {});
      }
    });
  }

  // sell product
  sellProduct(
      {@required String reqUid,
      @required String prodUid,
      @required int quantity}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('BuyerRequests')
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
    _createNotification(
        uid: reqUid,
        heading: 'Buy Request Approves',
        content: '${Constant.userName} accepted your Buy request');
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

  // cancel request
  cancelRequest({@required String reqUid}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('BuyerRequests')
        .doc(reqUid)
        .update({'status': 'cancel'});
  }
}
