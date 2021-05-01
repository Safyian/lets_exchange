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
import 'package:lets_exchange/widgets/catagory_productCard.dart';
import 'package:lets_exchange/widgets/product_card.dart';

class HomeProduct extends StatefulWidget {
  final List<ProductModel> product;
  HomeProduct({this.product});
  @override
  _HomeProductState createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
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
                  return CatagoryProductCard(prodList: widget.product[index]);
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
                    child: Text('Home Accessories',
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
