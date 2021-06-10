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
import 'package:lets_exchange/screens/add_product.dart';
import 'package:lets_exchange/screens/chat_screen.dart';
import 'package:lets_exchange/screens/my_chats.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productDetail;
  ProductDetailsScreen({@required this.productDetail});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _current = 0;
  bool favIcon;
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

  //************** ImagePicker from Gallery  ************/
  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    // ****** Crop Image *****
    if (_image != null) {
      _imgCropper();
    }
  }

  // ********** Image Cropper *******/
  _imgCropper() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
      compressFormat: ImageCompressFormat.png,
      cropStyle: CropStyle.rectangle,
    );
    this.setState(() {
      _cropImage = cropped;
    });
    _controller.setState(() {});
  }

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
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                              height: Get.height * 0.35,
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
                      Container(
                        width: Get.width,
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
                      ),
                      // Bottom Buttons
                    ],
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
      floatingActionButton: widget.productDetail.prodPostBy == Constant.userId
          ? SizedBox()
          : FloatingActionButton(
              backgroundColor: Constant.btnWidgetColor,
              onPressed: () {
                Get.to(ChatScreen(
                  Name: widget.productDetail.sellerName,
                  uid: widget.productDetail.prodPostBy,
                ));
              },
              elevation: 14,
              child: Icon(Icons.chat, size: Get.width * 0.055),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //
      bottomNavigationBar: widget.productDetail.prodPostBy == Constant.userId
          ? SizedBox()
          : BottomAppBar(
              color: Constant.primary,
              shape: CircularNotchedRectangle(),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: Get.width * 0.025),
                  // Buy Now Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      onPressed: () {
                        _showBuyDialog(model: widget.productDetail);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Constant.btnWidgetColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: Get.width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.025),
                  // Exchange Button
                  ElevatedButton(
                    onPressed: () {
                      _showExchange(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Constant.btnWidgetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Exchange',
                      style: TextStyle(
                        fontSize: Get.width * 0.042,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.025),
                  // Bid Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Constant.btnWidgetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

//
// user defined function for Buy Now
  void _showBuyDialog({@required ProductModel model}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Confirm!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please double check Product details:",
                style: TextStyle(
                    fontSize: Get.width * 0.04, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Get.width * 0.06),
              Row(
                children: [
                  Text(
                    'Product: ',
                    style: TextStyle(
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    model.prodName,
                    style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Constant.btnWidgetColor),
                  ),
                ],
              ),
              SizedBox(height: Get.width * 0.015),
              Row(
                children: [
                  Text(
                    'Price: ',
                    style: TextStyle(
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Rs. ${model.prodPrice.toInt()}",
                    style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            // Buy or Cancel buttons
            Container(
              width: Get.width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  // send Buy request
                  buyNow();
                },
                style: ElevatedButton.styleFrom(
                  primary: Constant.btnWidgetColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buy',
                  style: TextStyle(
                    fontSize: Get.width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Container(
              width: Get.width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
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
                    fontSize: Get.width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

//
  Future<void> _showExchange(BuildContext ctx) async {
    _controller = await _scaffoldKey.currentState.showBottomSheet(
      (ctx) => Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: Get.width * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: Constant.btnWidgetColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
                height: Get.height * 0.06,
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: Get.width * 0.08,
                  ),
                ),
              ),
              SizedBox(height: Get.width * 0.02),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please enter your Product details:",
                      style: TextStyle(
                          fontSize: Get.width * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: Get.width * 0.04),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _imgFromGallery();
                        },
                        child: Container(
                          width: Get.width * 0.22,
                          height: Get.width * 0.2,
                          decoration: BoxDecoration(
                              color: Constant.primary,
                              borderRadius: BorderRadius.circular(8)),
                          child: _cropImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _cropImage,
                                    fit: BoxFit.cover,
                                  ))
                              : Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: exName,
                      decoration: InputDecoration(hintText: 'Product Name'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter Product Name';
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: exDetail,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter Product Details';
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: Get.width * 0.02),
                    Center(
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Constant.btnWidgetColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (_cropImage != null) {
                                exchangeNow(
                                  productName: exName.text.toString(),
                                  productDetails: exDetail.text.toString(),
                                  file: _cropImage,
                                );
                              } else
                                Authentication.showError(
                                    'Empty', 'Please select Product image');
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.width * 0.04),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.width * 0.02),
            ],
          ),
        ),
      ),
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

// buy now method
  buyNow() async {
    String reqUid = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.productDetail.prodPostBy)
        .collection('BuyerRequests')
        .doc(reqUid)
        .set({
      'reqUid': reqUid,
      'buyerUid': Constant.userId,
      'productUid': widget.productDetail.prodUid,
      'productPrice': widget.productDetail.prodPrice,
      'productImg': widget.productDetail.prodImages[0],
      'status': 'pending',
      'time': DateTime.now(),
      'productName': widget.productDetail.prodName,
      'quantity': widget.productDetail.prodQuantity,
      'buyerName': Constant.userName,
    });
    Get.back();
  }

  // Exchange method
  exchangeNow({String productName, String productDetails, File file}) async {
    String reqUid = DateTime.now().millisecondsSinceEpoch.toString();
    String image = '';
    try {
      Get.defaultDialog(
        title: 'Please wait',
        middleText: 'Sending Request...',
      );
      //
      //Create a reference to the location you want to upload to in firebase
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('pictures')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      //Upload the file to firebase
      imageUploadTask = reference.putFile(file);

      // Waits till the file is uploaded then stores the download url
      await imageUploadTask.whenComplete(() {
        print('image uploaded');
      });
      // getting image url
      reference.getDownloadURL().then((url) async {
        image = url.toString();
        // **********
        if (image.isNotEmpty) {
          // ****** Storing User Data ******
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.productDetail.prodPostBy)
              .collection('ExchangeRequests')
              .doc(reqUid)
              .set({
            'reqUid': reqUid,
            'buyerUid': Constant.userId,
            'productUid': widget.productDetail.prodUid,
            'productPrice': widget.productDetail.prodPrice,
            'productImg': widget.productDetail.prodImages[0],
            'status': 'pending',
            'time': DateTime.now(),
            'productName': widget.productDetail.prodName,
            'quantity': widget.productDetail.prodQuantity,
            'buyerName': Constant.userName,
            'exchangeProductName': productName,
            'exchangeProductDetails': productDetails,
            'exchangeProductImg': image,
          });
          Get.back();

          Authentication.showError(
              'Success', 'Exchange Request Send Successfully');
          _controller.close();
        }
      });
    } catch (e) {}
  }
}
