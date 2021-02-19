import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _pass;
  final _formKey = GlobalKey<FormState>();
  bool showPass = false;
  File _image;
  File _cropImage;
  final picker = ImagePicker();

//************** ImagePicker from Camera  ************/
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });

    // ****** Crop Image *****
    if (_image != null) {
      _imgCropper();
    }
  }

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
  }

  // ********** Bottom Sheet *******/
  void showPicker() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: new Wrap(
          children: <Widget>[
            new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text('Photo Library'),
                onTap: () {
                  _imgFromGallery();
                  Get.back();
                }),
            new ListTile(
              leading: new Icon(Icons.photo_camera),
              title: new Text('Camera'),
              onTap: () {
                _imgFromCamera();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
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
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 22.0, right: Get.width * 0.06),
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
                        child: Text(Constant.appName,
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
        ),
      ),
      body: signUpBody(),
    );
  }

// ******** SignUp body widgets Ui *******
  Container signUpBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ******** Logo ********
                Container(
                    width: Get.width * 0.35,
                    height: Get.width * 0.35,
                    child: Image.asset(Constant.logo)),

                // ********* Profile Image *******
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () => showPicker(),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: customDecoration.copyWith(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey)),
                      child: _cropImage != null
                          ? ClipOval(
                              child: Image.file(_cropImage),
                            )
                          : Center(
                              child: Text(
                              'Profile Picture',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                            )),
                    ),
                  ),
                ),
                // ********* Name Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Constant.btnWidgetColor,
                        ),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your Name';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),

                // ********* Email Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Constant.btnWidgetColor,
                          )),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your Email';
                        } else if (EmailValidator.validate(val) == false) {
                          return 'Please enter valid Email';
                        } else if (EmailValidator.validate(val)) {
                          return null;
                        } else
                          return null;
                      },
                    ),
                  ),
                ),

                // ********* Password Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _pass,
                      obscureText: showPass ? false : true,
                      decoration: inputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Constant.btnWidgetColor,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                print('object');
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                              child: showPass
                                  ? Icon(
                                      Icons.visibility,
                                      color: Constant.btnWidgetColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Constant.btnWidgetColor,
                                    ))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter a Password';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),

                // *********** Terms & Conditions **********
                Text(
                  "by Signing up you're agreed to the Terms & conditions ",
                  style: TextStyle(fontSize: Get.width * 0.03),
                ),

                SizedBox(
                  height: Get.height * 0.01,
                ),

                // ********* Sign UP Button *********
                Container(
                  width: Get.width * 0.4,
                  height: Get.height * 0.05,
                  child: RaisedButton(
                    onPressed: signUp,
                    color: Constant.btnWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: Get.width * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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

// ******** Sign up Authentication method *******
  signUp() {
    if (_formKey.currentState.validate()) {
      if (_cropImage != null) {
        Authentication().signUp(
            name: _name.text.trim(),
            email: _email.text.trim(),
            pass: _pass.text.trim(),
            file: _cropImage);
      }
      if (_cropImage == null) {
        Authentication.showError('Empty', 'Please select your image');
      }
    }
  }
}
