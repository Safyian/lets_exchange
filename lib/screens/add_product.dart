import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/pick_address_from_map.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  var currentTime = DateTime.now();
  TextEditingController _prodName;
  TextEditingController _prodDescription;
  TextEditingController _prodPrice;
  int maxLength = 0;
  List<double> address = [];
  List catagoryList = [
    'Kitchen Accessories',
    'Home Accessories',
    'Computers & Mobiles',
    'Games',
    'Audio & Video',
    'Other'
  ];
  String _prodCatagory;
  int _prodQuantity = 1;
  double _prodLongitude;
  double _prodLatitude;
  File _prodCoverImg;
  List<Asset> images = <Asset>[];
  int _current = 0;
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';

  final picker = ImagePicker();

  @override
  void initState() {
    _prodDescription = TextEditingController();
    _prodName = TextEditingController();
    _prodPrice = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('bet === $_prodLatitude');
    print('bet === $images');

    return Scaffold(
      backgroundColor: Constant.background,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: customAppBar(),
      ),

      // ******* Body Start *******
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.025,
                ),
                // ********* Add Images ******
                (images.isNotEmpty)
                    ? Column(
                        children: [
                          CarouselSlider(
                            items: images
                                .map((item) => Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        child: Stack(
                                          children: <Widget>[
                                            AssetThumb(
                                              asset: item,
                                              quality: 100,
                                              width: 2000,
                                              height: 2000,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                // height: 200.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),

                            // end ///
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: images.map((url) {
                              int index = images.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          // File image = await ImagePicker.pickImage(
                          //     source: ImageSource.gallery, imageQuality: 100);
                          // _prodCoverImg = image;
                          // setState(() {});
                          loadAssets();
                        },
                        child: Container(
                          width: Get.width * 0.4,
                          height: Get.height * 0.18,
                          decoration: customDecoration.copyWith(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0)),
                          child:
                              // _prodCoverImg != null
                              // ? Image.file(
                              //     _prodCoverImg,
                              //     fit: BoxFit.contain,
                              //   )

                              Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 35.0,
                                color: Constant.btnWidgetColor,
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                'Add Images',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),

                // ********* Text Input Fields **********
                SizedBox(
                  height: Get.height * 0.012,
                ),
                // ********* Product Name **********
                customInputField(
                  controller: _prodName,
                  label: 'Product Name',
                  preIcon: Icons.label_important,
                  keyType: TextInputType.text,
                  errorMsg: 'Please enter Product Name',
                ),
                // ********* Product Description **********
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: (Get.height / 100) * 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _prodDescription,
                        decoration: InputDecoration(
                          hintText: 'Product Description ...',
                          prefixIcon: Icon(Icons.description,
                              color: Constant.btnWidgetColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          counterText: maxLength < 30 ? "$maxLength/30" : null,
                          counterStyle: TextStyle(color: Colors.red),
                        ),
                        onChanged: (value) {
                          maxLength = value.length;
                          setState(() {});
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter Product Description';
                          } else if (val.length < 30) {
                            return 'Description must contains atleast 30 words';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                // ********* Product Name **********
                customInputField(
                  controller: _prodPrice,
                  label: 'Product Price',
                  preIcon: Ionicons.md_pricetag,
                  keyType: TextInputType.number,
                  errorMsg: 'Please enter Product Price',
                ),
                // ******** Catagory DropDown ******
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: DropdownButtonFormField(
                    decoration: inputDecoration.copyWith(
                        prefixIcon: Icon(
                      Foundation.list_thumbnails,
                      color: Constant.btnWidgetColor,
                    )),
                    value: _prodCatagory,
                    onChanged: (value) {
                      setState(() {
                        _prodCatagory = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a Catagory' : null,
                    isExpanded: true,
                    // underline: Container(),
                    hint: Text(
                      'Select a Catagory',
                      style: TextStyle(color: Colors.black54),
                    ),
                    items: catagoryList.map((religionValue) {
                      return DropdownMenuItem(
                        value: religionValue,
                        child: Text(religionValue),
                      );
                    }).toList(),
                  ),
                  // ),
                ),

                // ********** Select From Map Button *********
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _AddressBtn(
                    text: 'Select your Location',
                    onTap: () async {
                      bool locationStatus = await Location().serviceEnabled();
                      if (locationStatus) {
                        address = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PickAddressFromMap()));

                        if (mounted) {
                          setState(() {
                            _prodLatitude = address[0];
                            _prodLongitude = address[1];
                          });
                        }
                      } else {
                        Authentication.showError(
                            'Error', 'Please turn on location');
                      }
                    },
                  ),
                ),

                // ********* Quantity ********
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Quantity: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: (Get.width / 100) * 4.5),
                      ),
                      // ******** Decrement *******
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _prodQuantity > 1
                                ? _prodQuantity--
                                : _prodQuantity = 1;

                            setState(() {
                              print(_prodQuantity);
                            });
                          },
                          child: quantityContainer(MaterialIcons.remove),
                        ),
                      ),

                      // ********* Quantity value *******
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: (Get.width / 100) * 20.0,
                          height: (Get.width / 100) * 16.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border:
                                  Border.all(color: Constant.btnWidgetColor)),
                          child: Text(
                            _prodQuantity.toString(),
                            style: TextStyle(fontSize: Get.width * 0.045),
                          ),
                        ),
                      ),
                      // ******** increament *******
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            print(_prodQuantity);
                            _prodQuantity++;
                            print(_prodQuantity);
                            setState(() {});
                          },
                          child: quantityContainer(
                            MaterialIcons.add,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // *********** Post Add Button *******
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width * 0.7,
                    height: (Get.height / 100) * 6,
                    child: RaisedButton(
                      onPressed: () => postProduct(),
                      color: Constant.btnWidgetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'POST',
                        style: TextStyle(
                            color: Colors.white, fontSize: Get.width * 0.05),
                      ),
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

// **************** Post Product method **************
  Future<void> postProduct() async {
    String image = '';
    UploadTask imageUploadTask;
    if (_formKey.currentState.validate()) {
      if (images != null && _prodLatitude != null && _prodLongitude != null) {
        try {
          Get.defaultDialog(
            title: 'Please wait',
            middleText: 'Posting your Product...',
            actions: [
              SpinKitFadingCircle(
                color: Constant.btnWidgetColor,
                size: Get.width * 0.12,
              ),
            ],
          );
          //
          // //Create a reference to the location you want to upload to in firebase
          // Reference reference = FirebaseStorage.instance
          //     .ref()
          //     .child('pictures')
          //     .child(DateTime.now().millisecondsSinceEpoch.toString());

          // //Upload the file to firebase
          // imageUploadTask = reference.putFile(_prodCoverImg);

          // // Waits till the file is uploaded then stores the download url
          // await imageUploadTask.whenComplete(() {
          //   print('image uploaded');
          // });
          // // getting image url
          // reference.getDownloadURL().then((url) async {
          //   image = url.toString();

          for (var imageFile in images) {
            await Services().postImage(imageFile).then((downloadUrl) {
              imageUrls.add(downloadUrl.toString());
            });

            setState(() {});
          }
          print('Images are here = $imageUrls');
          // ******* initialize model values *********
          var currentTime = DateTime.now();
          ProductModel addProductModel = ProductModel(
            prodName: _prodName.text.toString(),
            sellerName: Constant.userName,
            prodUid: currentTime.microsecondsSinceEpoch.toString(),
            prodStatus: 'pending',
            prodDescription: _prodDescription.text.toString(),
            prodCatagory: _prodCatagory,
            prodQuantity: _prodQuantity,
            prodPrice: double.parse(_prodPrice.text.toString()),
            latitude: _prodLatitude,
            longitude: _prodLongitude,
            prodImages: imageUrls,
            prodDate: currentTime.toString(),
            prodPostBy: Constant.userId,
            favouriteBy: [],
          );
          await FirebaseFirestore.instance
              .collection('Products')
              .doc(addProductModel.prodUid)
              .set(addProductModel.toMap())
              .then((value) {
            _prodName.clear();
            _prodDescription.clear();
            _prodPrice.clear();
            _prodCatagory = null;
            _prodQuantity = 1;
            _prodLongitude = null;
            _prodLatitude = null;
            images.clear();
            setState(() {});
            Get.back();
            Authentication.showError(
                'Success', 'Your Product is Posted Successfully!');
            // });
          });
        } catch (e) {
          Get.back();
          Authentication.showError('Error', '${e.message}');
        }
      } else if (images == null && _prodLatitude != null)
        Authentication.showError('Empty', 'Please add a Picture');
      else if (images != null && _prodLatitude == null)
        Authentication.showError('Empty', 'Please select you Location');
      else
        Authentication.showError('Empty', 'Please add Picture and Location');
    }
  }

// ********** AppBar *********
  AppBar customAppBar() {
    return AppBar(
      elevation: 0.0,
      leading: Container(),
      flexibleSpace: Container(
        color: Constant.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 22.0, right: Get.width * 0.06),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Constant.iconColor,
                        size: 28,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 22.0,
                    ),
                    child: Text('Add Product',
                        style: GoogleFonts.pacifico(
                          color: Constant.iconColor,
                          fontSize: Get.width * 0.055,
                          // fontWeight: FontWeight.bold,
                        )),
                  ),
                  Spacer(),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container quantityContainer(IconData icon) {
    return Container(
      width: (Get.width / 100) * 12.0,
      height: (Get.width / 100) * 12.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  // ******** TextFormField *******
  Padding customInputField({
    TextEditingController controller,
    String label,
    IconData preIcon,
    TextInputType keyType,
    String errorMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: inputDecoration.copyWith(
            labelText: label,
            prefixIcon: Icon(preIcon, color: Constant.btnWidgetColor)),
        validator: (val) {
          if (val.isEmpty) {
            return errorMsg;
          } else
            return null;
        },
        keyboardType: keyType,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  // ********* Multi Image Picker ********
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      // _error = error;
      print('image = $images');
    });
  }
}

// Button Select your location
class _AddressBtn extends StatelessWidget {
  final String text;
  final Function onTap;
  const _AddressBtn({
    @required this.text,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 3,
          //     color: Colors.grey,
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MaterialIcons.location_on,
              color: Colors.red[700],
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
