import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/widgets/product_card.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<ProductModel> _myProduct = [];

  @override
  void initState() {
    getMyProducts();
    print('bet bet bet bet bet ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: customAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ********** GridView Starts here ********
            StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
              itemCount: _myProduct.length,
              itemBuilder: (context, index) {
                print('post by = ${_myProduct[index].prodPostBy}');
                // ********* Card ********
                return ProductCard(prodList: _myProduct[index]);
              },
              staggeredTileBuilder: (_) => StaggeredTile.fit(2),
            ),
          ],
        ),
      ),
    );
  }

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
                  // Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 22.0,
                    ),
                    child: Text('My Products',
                        style: GoogleFonts.roboto(
                          color: Constant.iconColor,
                          fontSize: Get.width * 0.055,
                          fontWeight: FontWeight.w500,
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

  getMyProducts() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .snapshots()
        .listen((value) async {
      if (value.docs != null) {
        _myProduct.clear();
        value.docs.forEach((element) {
          var prod = ProductModel.fromMap(element.data());
          if (prod.prodPostBy == Constant.userId) {
            _myProduct.add(prod);
          }
        });
        setState(() {});
      }
    });
  }
}
