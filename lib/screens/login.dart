import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Let's Exchange"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ******** Logo ********
                Container(
                    width: Get.width * 0.35,
                    height: Get.width * 0.35,
                    child: Image.asset(Constant().logo)),

                // ********* Email Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _emailController,
                      onChanged: (val) {
                        val = _emailController.text.toString();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'xyz@abc.com',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                      onChanged: (val) {
                        val = _passController.text.toString();
                      },
                      obscureText: showPass ? false : true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              print('object');
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            child: showPass
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                      ),
                    ),
                  ),
                ),

                // ********* Login Button *********
                Container(
                  width: Get.width * 0.4,
                  height: Get.height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty &&
                          _passController.text.isEmpty) {
                        Get.snackbar('Empty!', 'Please Enter required Fields',
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (_emailController.text.isEmpty &&
                          _passController.text.isNotEmpty) {
                        Get.snackbar('Empty!', 'Please Enter your Email',
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (_emailController.text.isNotEmpty &&
                          _passController.text.isEmpty) {
                        Get.snackbar('Empty!', 'Please Enter Password',
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (_emailController.text.isNotEmpty &&
                          _passController.text.isNotEmpty) {
                        Authentication()
                            .login(_emailController.text, _passController.text);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.bold),
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
                              color: Colors.blue,
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
}
