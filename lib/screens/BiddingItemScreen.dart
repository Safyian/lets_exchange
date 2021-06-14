import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
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
  File _image;
  File _cropImage;
  UploadTask imageUploadTask;
  TextEditingController exName = TextEditingController();
  TextEditingController exDetail = TextEditingController();
  final picker = ImagePicker();
  PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool open = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    locationFromCordinates(Coordinates(
        widget.productDetail.latitude, widget.productDetail.longitude));
    prodDate();
    favIcon = widget.productDetail.favouriteBy.contains(Constant.userId)
        ? true
        : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
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
                      SizedBox(
                        height: Get.height * 0.01,
                      ),

                      // ********** Product Price ********
                      // Container(
                      //   width: Get.width,
                      //   child: Card(
                      //     elevation: 1.0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ),
                      //           Center(
                      //             child: Text(
                      //               'Bidding',
                      //               style: GoogleFonts.roboto(
                      //                   fontSize: Get.width * 0.05,
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors.black),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ), //
                      //           Text(
                      //             '${Services().formateMoney(widget.productDetail.prodPrice)}',
                      //             style: GoogleFonts.roboto(
                      //                 fontSize: Get.width * 0.05,
                      //                 fontWeight: FontWeight.w500,
                      //                 color: Colors.red),
                      //           ),
                      //           // ),
                      //           // ********* Prod Name *********
                      //           Text(
                      //             widget.productDetail.prodName,
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.045,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ), // ********* Prod Description *********
                      //           Text(
                      //             'Description:',
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.042,
                      //             ),
                      //           ),
                      //           Text(
                      //             widget.productDetail.prodDescription,
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.038,
                      //               color: Colors.grey[600],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ), // ********* Prod Description *********
                      //           Row(
                      //             children: [
                      //               Text(
                      //                 'Stock Availiable:',
                      //                 style: GoogleFonts.roboto(
                      //                   fontSize: Get.width * 0.042,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 width: 8.0,
                      //               ),
                      //               Text(
                      //                 "${widget.productDetail.prodQuantity}",
                      //                 style: GoogleFonts.roboto(
                      //                   fontSize: Get.width * 0.042,
                      //                   // color: Colors.grey[600],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ),
                      //           // ****** Location of Product ******
                      //           Text(
                      //             'Location:',
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.042,
                      //             ),
                      //           ),
                      //           Text(
                      //             address ?? '',
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.038,
                      //               color: Colors.grey[600],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ),

                      //           // ********* Prod Posted Date ******
                      //           Text(
                      //             'Posted Date:',
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.042,
                      //             ),
                      //           ),
                      //           Text(
                      //             duration,
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.038,
                      //               color: Colors.grey[600],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ),
                      //           // ********* Prod Seller Name ******
                      //           Text(
                      //             'Seller Name:',
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.042,
                      //             ),
                      //           ),
                      //           Text(
                      //             widget.productDetail.sellerName,
                      //             style: GoogleFonts.roboto(
                      //               fontSize: Get.width * 0.038,
                      //               color: Colors.grey[600],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: Get.height * 0.01,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Bottom Buttons
                    ],
                  ),
                ),
              ),
              // Type message textfield
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: Get.width,
                  child: TextFormField(
                    // controller: chatController,
                    style: TextStyle(fontSize: Get.width * 0.04),
                    decoration: inputDecoration.copyWith(
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          // await sendMessage();
                          // chatController.clear();
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
      // Bottom Section with Floating Chat Button
      //
      // ********* Chat Floating Button *******
      // floatingActionButton: widget.productDetail.prodPostBy == Constant.userId
      //     ? SizedBox()
      //     : FloatingActionButton(
      //         backgroundColor: Constant.btnWidgetColor,
      //         onPressed: () {
      //           Get.to(ChatScreen(
      //             Name: widget.productDetail.sellerName,
      //             uid: widget.productDetail.prodPostBy,
      //           ));
      //         },
      //         elevation: 14,
      //         child: Icon(Icons.chat, size: Get.width * 0.055),
      //       ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

//

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
}