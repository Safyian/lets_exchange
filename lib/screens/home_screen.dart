import 'package:flutter/material.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Authentication().signOut();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
