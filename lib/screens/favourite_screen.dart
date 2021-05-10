import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/product_details.dart';

import 'package:lets_exchange/widgets/product_card.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<ProductModel> fvrtList = [];
  List<ProductModel> fvrtFilter = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getFvrtProducts();
    super.initState();
    searchController.addListener(() {
      filterList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.primary,
        elevation: 0.0,
      ),
      backgroundColor: Constant.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
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
                    controller: searchController,
                    style: TextStyle(fontSize: Get.width * 0.04),
                    decoration: inputDecoration.copyWith(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Constant.btnWidgetColor,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchController.clear();
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
                  itemCount:
                      isSearching == true ? fvrtFilter.length : fvrtList.length,
                  itemBuilder: (context, index) {
                    ProductModel prodModel = isSearching == true
                        ? fvrtFilter[index]
                        : fvrtList[index];
                    // ********* Card ********
                    return ProductCard(
                      prodList: prodModel,
                      onTap: () {
                        Get.to(ProductDetailsScreen(productDetail: prodModel));
                      },
                      delete: false,
                    );
                  },
                  staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                ),
              ],
            ),
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
        fvrtList.clear();
        event.docs.forEach((element) async {
          FirebaseFirestore.instance
              .collection('Products')
              .doc(element.id)
              //     .snapshots()
              //     .listen((event) async {
              //   print('bbb = $event');
              //   await fvrtList.add(ProductModel.fromMap(event.data()));
              //   setState(() {});
              // });
              .get()
              .then((value) {
            fvrtList.add(ProductModel.fromMap(value.data()));
            setState(() {});
          });
        });
        setState(() {});
      }
    });
  }

  //
  filterList() {
    List<ProductModel> _product = [];
    _product.addAll(fvrtList);
    if (searchController.text.isNotEmpty) {
      _product.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String productName = element.prodName.toLowerCase();
        return productName.contains(searchTerm);
      });

      setState(() {
        fvrtFilter = _product;
      });
    } else {
      setState(() {
        searchController.text.isEmpty;
      });
    }
  }
}
