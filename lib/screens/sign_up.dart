import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passController;
  bool showPass = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.clear();
    _emailController.clear();
    _passController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign up'),
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

                // ********* Name Text Field *********
                Container(
                  width: Get.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _nameController,
                      onChanged: (val) {
                        val = _nameController.text.toString();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'xyz',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),

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

                // ********* _passController Text Field *********
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
                        hintText: '_passController',
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
                        Get.snackbar('Empty!', 'Please Enter _passController',
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (_emailController.text.isNotEmpty &&
                          _passController.text.isNotEmpty) {
                        Authentication().signUp(
                            _emailController.text, _passController.text);
                      }
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: Get.width * 0.045,
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
}
