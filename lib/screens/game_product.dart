import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/product_details.dart';

class GameProduct extends StatefulWidget {
  final List<AddProductModel> product;
  GameProduct({this.product});
  @override
  _GameProductState createState() => _GameProductState();
}

class _GameProductState extends State<GameProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: customAppBar(),
      ),
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
                itemCount: widget.product.length,
                itemBuilder: (context, index) {
                  // ********* Card ********
                  return GestureDetector(
                    onTap: () {
                      Get.to(ProductDetailsScreen(
                        productDetail: widget.product[index],
                      ));
                    },
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ************ Product Image ********
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Stack(
                              children: [
                                SpinKitPulse(
                                  color: Constant.btnWidgetColor,
                                  size: 65,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                  child: Image.network(
                                      widget.product[index].prodImages[0],
                                      fit: BoxFit.cover),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),

                          // ********* Product Name Text ********
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.product[index].prodName,
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: Get.width * 0.035),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          // ********* Product Price Text ********
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${Services().formateMoney(widget.product[index].prodPrice)}',
                              style: GoogleFonts.roboto(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.width * 0.035),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: RatingBar.builder(
                              initialRating: 3.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.5),
                              itemSize: Get.width * 0.04,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (_) => StaggeredTile.fit(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ********** AppBar *********
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
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 22.0,
                    ),
                    child: Text('Games',
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
}
