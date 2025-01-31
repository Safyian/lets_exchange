import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/add_product.dart';
import 'package:lets_exchange/screens/exchange_screen.dart';
import 'package:lets_exchange/screens/my_chats.dart';
import 'package:lets_exchange/screens/my_products.dart';
import 'package:lets_exchange/screens/orders_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(
                Constant.userEmail,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              accountName: Text(
                Constant.userName,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              currentAccountPicture: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constant.background,
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
              decoration: BoxDecoration(color: Constant.primary),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(
                  Icons.home,
                  color: Constant.btnWidgetColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ProductModel productModel = ProductModel(
                  prodName: '',
                  sellerName: '',
                  prodUid: '',
                  prodStatus: '',
                  prodDescription: '',
                  prodPrice: null,
                  prodCatagory: null,
                  prodImages: null,
                  prodPostBy: '',
                  prodDate: '',
                  longitude: null,
                  latitude: null,
                  prodQuantity: null,
                  favouriteBy: null,
                  prodBidding: 'false',
                  biddingStatus: 'end',
                );
                Get.to(AddProduct(productModel: productModel));
              },
              child: ListTile(
                title: Text('Add Product'),
                leading: Icon(
                  Icons.add_box,
                  color: Constant.btnWidgetColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(MyProducts(
                  fromScreen: '',
                ));
              },
              child: ListTile(
                title: Text('My Products'),
                leading: Icon(
                  Icons.label_important,
                  color: Constant.btnWidgetColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(MyChats());
              },
              child: ListTile(
                title: Text('Chat'),
                leading: Icon(
                  Icons.chat,
                  color: Constant.btnWidgetColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(OrderScreen());
              },
              child: ListTile(
                title: Text('Orders'),
                leading: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Constant.btnWidgetColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(ExchangeScreen());
              },
              child: ListTile(
                title: Text('Exchange'),
                leading: Icon(
                  Icons.autorenew,
                  color: Constant.btnWidgetColor,
                ),
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
