import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/sign_up.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController;
  TextEditingController _passController;
  final _formKey = GlobalKey<FormState>();
  bool showPass = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passController.clear();
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
              ],
            ),
          ),
        ),
      ),
      body: loginBody(),
    );
  }

// ******** Login body Ui *********
  Container loginBody() {
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

                // ********* Email Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email,
                              color: Constant.btnWidgetColor)),
                      keyboardType: TextInputType.emailAddress,
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
                      controller: _passController,
                      obscureText: showPass ? false : true,
                      decoration: inputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon:
                              Icon(Icons.lock, color: Constant.btnWidgetColor),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                print('object');
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                              child: showPass
                                  ? Icon(Icons.visibility,
                                      color: Constant.btnWidgetColor)
                                  : Icon(Icons.visibility_off,
                                      color: Constant.btnWidgetColor))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter a Password';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),

                // ********* Login Button *********
                Container(
                  width: Get.width * 0.4,
                  height: Get.height * 0.05,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Constant.btnWidgetColor,
                    onPressed: logIn,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Get.height * 0.02,
                ),
                // *********** Sign up Button **********
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: Get.width * 0.045),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(SignUp());
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: Get.width * 0.05,
                              color: Constant.iconColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ****** Login Authentication method ******
  logIn() {
    if (_formKey.currentState.validate()) {
      Authentication()
          .login(_emailController.text.trim(), _passController.text.trim());
    }
  }
}
