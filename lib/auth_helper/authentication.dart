import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/const/const.dart';

import 'package:lets_exchange/screens/home_screen.dart';
import 'package:lets_exchange/screens/login.dart';

class Authentication {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  UploadTask imageUploadTask;

  // ******* Sign up method *******
  signUp({String name, String email, String pass, File file}) async {
    String image = '';
    try {
      Get.defaultDialog(
        title: 'Please wait',
        middleText: 'Creating User...',
      );
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      print('test === ${result.user.uid}');
      final User user = result.user;

      if (user != null) {
        print('User in ...');

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
                .doc(user.uid)
                .set({
              'uid': user.uid,
              'name': name,
              'image': image,
              'email': email,
            });
            Constant.userName = name;
            Constant.userEmail = email;
            Constant.userId = user.uid;
            Constant.userImage = image;
            Get.back();
            showError('Success', 'Account created Successfully!');
            Future.delayed(Duration(seconds: 2))
                .then((value) => Get.offAll(HomeScreen()));
          }
        });
      }
      //
    } catch (e) {
      print('print ${e.code}');
      print('print e $e');
      Get.back();
      if (e.code == 'email-already-in-use')
        showError(
            'Error', 'You already have an account associated with this Email.');
      else if (e.code == 'wrong-password') {
        showError('Error', 'Password is Incorrect. Please try again.');
      } else if (e.code == 'invalid-email') {
        showError('Error', 'Please enter a valid Email.');
      }
    }
  }

  // ********* Login method ********
  login(String email, String pass) async {
    try {
      Get.defaultDialog(
        title: 'Please wait',
        middleText: 'Loging in...',
      );
      final result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      final User user = result.user;

      if (user != null) {
        // ****** Storing user Info ******
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          print('value = ${value.data()['image']}');
          Constant.userId = value.data()['uid'];
          Constant.userEmail = value.data()['email'];
          Constant.userName = value.data()['name'];
          Constant.userImage = value.data()['image'];
        });
        //
        Get.back();
        Get.offAll(HomeScreen());
      }
    } catch (e) {
      print('print == ${e.code}');
      Get.back();
      if (e.code == 'user-not-found')
        showError('Error', 'There is no account associated with this email.');
      else if (e.code == 'wrong-password') {
        showError('Error', 'Password is Incorrect. Please try again.');
      } else if (e.code == 'invalid-email') {
        showError('Error', 'Please enter a valid Email.');
      }
    }
  }

  // ********* Signout ******
  signOut() async {
    Get.defaultDialog(
      title: 'Please wait',
      middleText: 'Loging out...',
    );
    await _auth.signOut();
    Get.offAll(LoginScreen());
  }

// ******* Snackbar *******
  static showError(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  // ****** Password Validator ********
  validatePassword(String password) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(password);
  }
}
