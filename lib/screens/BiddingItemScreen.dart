import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/chat_screen.dart';

class BiddingItemScreen extends StatefulWidget {
  final ProductModel productDetail;

  BiddingItemScreen({@required this.productDetail});

  @override
  _BiddingItemScreenState createState() => _BiddingItemScreenState();
}

class _BiddingItemScreenState extends State<BiddingItemScreen> {
  int _current = 0;
  bool favIcon;
  bool exCheck = false;
  String address;
  String date;
  String duration;

  UploadTask imageUploadTask;
  TextEditingController exName = TextEditingController();
  TextEditingController exDetail = TextEditingController();
  final picker = ImagePicker();
  final _controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool open = false;
  final _formKey = GlobalKey<FormState>();
  List bidsList = [];
  // List winner = [];

  @override
  void initState() {
    locationFromCordinates(Coordinates(
        widget.productDetail.latitude, widget.productDetail.longitude));
    prodDate();
    favIcon = widget.productDetail.favouriteBy.contains(Constant.userId)
        ? true
        : false;
    fetchBids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bidsList.sort((a, b) => b['bidPrice'].compareTo(a['bidPrice']));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Constant.iconColor,
              ),
              onPressed: () {
                showInfo();
              })
        ],
        title: Container(
          width: Get.width * 0.8,
          child: Text(
            widget.productDetail.prodName,
            style: TextStyle(
                color: Constant.iconColor, fontSize: Get.width * 0.045),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Container(
            width: Get.width,
            height: Get.height,
            color: Constant.background,
            child: Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ******* Prod Images Carousel Slider *******
                        Container(
                          child: CarouselSlider(
                            items: widget.productDetail.prodImages
                                .map((item) => Container(
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            SpinKitPulse(
                                              color: Constant.btnWidgetColor,
                                              size: 65,
                                            ),
                                            Center(
                                              child: Image.network(
                                                item,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                autoPlay: false,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                height: Get.height * 0.3,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          ),
                        ),
                        // ******** Indicator Dots ********
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.productDetail.prodImages.map((url) {
                            int index =
                                widget.productDetail.prodImages.indexOf(url);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Constant.btnWidgetColor
                                    : Colors.grey[400],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: Get.height * 0.01),

                        // ********** Bid Start Price ********
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start at Rs. ${widget.productDetail.prodPrice.toInt()}',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.04,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Ended',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.04,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bidsList.isEmpty
                                      ? ''
                                      : 'Max Rs. ${bidsList.first['bidPrice']}',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.042,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  bidsList.isEmpty
                                      ? ''
                                      : 'Bid By: ${bidsList.first['bidBy']}',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.042,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Bidding Live List
                      ],
                    ),
                  ),
                ),

                // bids List
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: widget.productDetail.prodPostBy == Constant.userId
                        ? EdgeInsets.only(bottom: Get.height * 0.025)
                        : EdgeInsets.only(bottom: Get.height * 0.04),
                    height: Get.height * 0.47,
                    child: ListView.builder(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: bidsList.length,
                        itemBuilder: (_, index) {
                          int position = index + 1;
                          return bidCard(index, position);
                        }),
                  ),
                ),

                // Type message textfield
                (widget.productDetail.prodPostBy == Constant.userId ||
                        widget.productDetail.prodBidding == 'false')
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: Get.width,
                          child: TextFormField(
                            controller: _controller,
                            style: TextStyle(fontSize: Get.width * 0.04),
                            decoration: inputDecoration.copyWith(
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    await bidOnItem(_controller.text);
                                  }
                                  _controller.clear();
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
                                  borderSide:
                                      BorderSide(color: Colors.grey[200])),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey[200])),
                              hintText: 'Quote your Bid',
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bid card
  Padding bidCard(int index, int position) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      Constant.userName == bidsList[index]['bidBy']
                          ? 'YOU'
                          : 'By: ${bidsList[index]['bidBy']}',
                      style: TextStyle(
                        fontSize: Get.width * 0.042,
                        color: Constant.userName == bidsList[index]['bidBy']
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(width: Get.width * 0.01),
                    Spacer(),
                    CircleAvatar(
                      radius: Get.width * 0.032,
                      backgroundColor: Constant.btnWidgetColor,
                      child: Text(
                        '$position',
                        style: TextStyle(
                          fontSize: Get.width * 0.038,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.width * 0.02),
                Row(
                  children: [
                    Text(
                      'Rs. ${bidsList[index]['bidPrice']}',
                      style: TextStyle(
                        fontSize: Get.width * 0.042,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed:
                          (widget.productDetail.prodPostBy != Constant.userId ||
                                  bidsList[index]['isWinner'] == "true")
                              ? null
                              : () {
                                  // fetchWinner(uid: bidsList[index]['bidId']);
                                  acceptBid(uid: bidsList[index]['bidId']);
                                },
                      style: ElevatedButton.styleFrom(
                          primary: Constant.btnWidgetColor),
                      child: Text('ACCEPT',
                          style: TextStyle(
                              fontSize: Get.width * 0.036,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(width: Get.width * 0.01),
                    ElevatedButton(
                      onPressed: (bidsList[index]['status'] == 'active' &&
                                  bidsList[index]['isWinner'] == "true" &&
                                  bidsList[index]['bidId'] == Constant.userId ||
                              widget.productDetail.prodPostBy ==
                                  Constant.userId)
                          ? () {
                              Get.to(ChatScreen(
                                uid: bidsList[index]['bidId'],
                                Name: bidsList[index]['bidBy'],
                              ));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          primary: Constant.btnWidgetColor),
                      child: Text('CHAT',
                          style: TextStyle(
                              fontSize: Get.width * 0.036,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                SizedBox(height: Get.width * 0.01),
                bidsList[index]['isWinner'] == "true"
                    ? Text(
                        'WINNER',
                        style: TextStyle(
                          fontSize: Get.width * 0.042,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Bid on item method
  bidOnItem(String bidPrice) async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productDetail.prodUid)
        .collection('Biddings')
        .doc(Constant.userId)
        .set({
      'bidBy': Constant.userName,
      'bidId': Constant.userId,
      'bidPrice': bidPrice,
      'status': 'active',
      'bidStatus': 'pending',
      'isWinner': 'false',
    }, SetOptions(merge: true));
    _createNotification(
        uid: widget.productDetail.prodPostBy,
        heading: 'NEW BID',
        content: '${Constant.userName} Bid Rs. $bidPrice on your Product');
  }

// accept bid method
  acceptBid({String uid}) async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productDetail.prodUid)
        .collection('Biddings')
        .doc(uid)
        .update({
      'isWinner': 'true',
    });

    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productDetail.prodUid)
        .collection('Biddings')
        .where('bidId', isNotEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.productDetail.prodUid)
            .collection('Biddings')
            .doc(element.id)
            .update({'bidStatus': 'cancel'});
      });
    });

    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productDetail.prodUid)
        .update({
      'biddingStatus': 'end',
      'prodStatus': widget.productDetail.prodQuantity == 1 ? 'sold' : 'pending',
      'prodQuantity': widget.productDetail.prodQuantity == 1
          ? 0
          : (widget.productDetail.prodQuantity - 1)
    });
    _createNotification(
        uid: uid,
        heading: 'Bid Won',
        content: 'CONGRATULATIONS! your Bid is accepted');
  }

  // read bids
  fetchBids() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productDetail.prodUid)
        .collection('Biddings')
        .where('bidStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        bidsList.clear();
        event.docs.forEach((element) {
          bidsList.add(element.data());
        });
        setState(() {
          bidsList.sort((a, b) => b['bidPrice'].compareTo(a['bidPrice']));
        });
      }
    });
  }

  // ******* Get Location from Coordinates *******
  locationFromCordinates(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // print('add Country  == ${addresses.first.countryName}');
    // print('add City == ${addresses.first.locality}');
    // print('add address == ${addresses.first.subLocality}');
    print('add address == ${addresses.first.addressLine}');
    address = addresses.first.addressLine;
    print('add$address');
    setState(() {});
  }

  // ******** Date of Product Formatted ******
  prodDate() {
    final DateFormat formatter = DateFormat('MMMM d, y');
    date = formatter.format(DateTime.parse(widget.productDetail.prodDate));
    print("formatted$date");
    duration = DateTime.now()
                .difference(DateTime.parse(widget.productDetail.prodDate))
                .inDays ==
            0
        ? DateTime.now()
                    .difference(DateTime.parse(widget.productDetail.prodDate))
                    .inHours ==
                0
            ? "${DateTime.now().difference(DateTime.parse(widget.productDetail.prodDate)).inMinutes} minutes ago"
            : DateTime.now()
                        .difference(
                            DateTime.parse(widget.productDetail.prodDate))
                        .inHours ==
                    1
                ? "${DateTime.now().difference(DateTime.parse(widget.productDetail.prodDate)).inHours} hour ago"
                : "${DateTime.now().difference(DateTime.parse(widget.productDetail.prodDate)).inHours} hours ago"
        : DateTime.now()
                    .difference(DateTime.parse(widget.productDetail.prodDate))
                    .inDays ==
                1
            ? "${DateTime.now().difference(DateTime.parse(widget.productDetail.prodDate)).inDays} day ago"
            : "${DateTime.now().difference(DateTime.parse(widget.productDetail.prodDate)).inDays} days ago";
    print('differenceInDays = $duration');
    setState(() {});
  }

  //
  showInfo() {
    return Get.defaultDialog(
      title: 'Information',
      middleText: 'Bidding',
      actions: [
        // ********** Product Price ********
        Container(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * 0.01,
                ), //
                Text(
                  '${Services().formateMoney(widget.productDetail.prodPrice)}',
                  style: GoogleFonts.roboto(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
                // ),
                // ********* Prod Name *********
                Text(
                  widget.productDetail.prodName,
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ), // ********* Prod Description *********
                Text(
                  'Description:',
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.042,
                  ),
                ),
                Text(
                  widget.productDetail.prodDescription,
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ), // ********* Prod Description *********
                Row(
                  children: [
                    Text(
                      'Stock Availiable:',
                      style: GoogleFonts.roboto(
                        fontSize: Get.width * 0.042,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${widget.productDetail.prodQuantity}",
                      style: GoogleFonts.roboto(
                        fontSize: Get.width * 0.042,
                        // color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                // ****** Location of Product ******
                Text(
                  'Location:',
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.042,
                  ),
                ),
                Text(
                  address ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),

                // ********* Prod Posted Date ******
                Text(
                  'Posted Date:',
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.042,
                  ),
                ),
                Text(
                  duration,
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                // ********* Prod Seller Name ******
                Text(
                  'Seller Name:',
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.042,
                  ),
                ),
                Text(
                  widget.productDetail.sellerName,
                  style: GoogleFonts.roboto(
                    fontSize: Get.width * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
              ],
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(primary: Constant.btnWidgetColor),
          child: Text('Close',
              style: TextStyle(
                  fontSize: Get.width * 0.04, fontWeight: FontWeight.w600)),
        )
      ],
    );
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
