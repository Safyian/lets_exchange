import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/add_product.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(Constant.userEmail),
              accountName: Text(Constant.userName),
              currentAccountPicture: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      Constant.userImage,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // decoration: BoxDecoration(color: Colors.blue),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(AddProduct());
              },
              child: ListTile(
                title: Text('Add Product'),
                leading: Icon(Icons.add_box, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My Products'),
                leading: Icon(Icons.label_important, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Chat'),
                leading: Icon(Icons.chat, color: Colors.blue),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(
                  Icons.help,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Authentication().signOut();
              },
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.exit_to_app,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
