import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/BiddingItemScreen.dart';
import 'package:lets_exchange/screens/bid_itemCard.dart';
import 'package:lets_exchange/screens/my_products.dart';
import 'package:lets_exchange/screens/product_details.dart';

import 'package:lets_exchange/widgets/product_card.dart';

class BiddingScreen extends StatefulWidget {
  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  List<ProductModel> bidsList = [];
  List<ProductModel> bidsFilter = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getbiddingProducts();
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
        centerTitle: true,
        title: Text(
          'Bidding',
          style: GoogleFonts.pacifico(
            fontSize: Get.width * 0.055,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        leading: Container(),
        flexibleSpace: Container(
          color: Constant.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    // ********* POST Button *********
                    GestureDetector(
                      onTap: () {
                        Get.to(MyProducts(fromScreen: 'Bidding'));
                      },
                      child: Container(
                        width: 65,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Constant.btnColor,
                        ),
                        child: Center(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                bidsList.length == 0
                    ? Container(
                        height: Get.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(
                          'Go to Home Page',
                          style: GoogleFonts.roboto(
                            fontSize: Get.width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 6.0,
                        mainAxisSpacing: 6.0,
                        itemCount: isSearching == true
                            ? bidsFilter.length
                            : bidsList.length,
                        itemBuilder: (context, index) {
                          ProductModel prodModel = isSearching == true
                              ? bidsFilter[index]
                              : bidsList[index];
                          // ********* Card ********
                          return BidCard(
                            prodList: prodModel,
                            onTap: () {
                              Get.to(
                                  BiddingItemScreen(productDetail: prodModel));
                            },
                            delete: true,
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
  getbiddingProducts() async {
    FirebaseFirestore.instance
        .collection('Products')
        .where('prodStatus', isEqualTo: 'bidding')
        .snapshots()
        .listen((event) {
      bidsList.clear();
      event.docs.forEach((element) {
        bidsList.add(ProductModel.fromMap(element.data()));
      });
      setState(() {});
    });
  }

  //
  filterList() {
    List<ProductModel> _product = [];
    _product.addAll(bidsList);
    if (searchController.text.isNotEmpty) {
      _product.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String productName = element.prodName.toLowerCase();
        return productName.contains(searchTerm);
      });

      setState(() {
        bidsFilter = _product;
      });
    } else {
      setState(() {
        searchController.text.isEmpty;
      });
    }
  }
}
