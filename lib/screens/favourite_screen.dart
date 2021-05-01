import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';

import 'package:lets_exchange/widgets/product_card.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<ProductModel> fvrtList = [];
  @override
  void initState() {
    getFvrtProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.primary,
        elevation: 0.0,
      ),
      backgroundColor: Constant.background,
      body: SingleChildScrollView(
        child: Container(
          // width: Get.width,
          // height: Get.height,
          color: Constant.background,
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              // ********** Search Bar ********
              Container(
                width: Get.width,
                child: TextFormField(
                  // controller: search,
                  style: TextStyle(fontSize: Get.width * 0.04),
                  decoration: inputDecoration.copyWith(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Constant.btnWidgetColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // search.clear();
                      },
                      child: Icon(
                        Icons.clear,
                        color: Constant.btnWidgetColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: 'Search',
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.01,
              ),
              // ********** GridView Starts here ********
              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                itemCount: fvrtList.length,
                itemBuilder: (context, index) {
                  // ********* Card ********
                  return ProductCard(prodList: fvrtList[index]);
                },
                staggeredTileBuilder: (_) => StaggeredTile.fit(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ************** Favourite Item List **********
  //
  getFvrtProducts() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .collection('favourites')
        .snapshots()
        .listen((event) {
      if (event.docs != null) {
        event.docs.forEach((element) async {
          fvrtList.clear();
          FirebaseFirestore.instance
              .collection('Products')
              .doc(element.id)
              .snapshots()
              .listen((event) async {
            print('bbb = $event');
            await fvrtList.add(ProductModel.fromMap(event.data()));
            setState(() {});
          });
        });
        setState(() {});
      }
    });
  }
}
