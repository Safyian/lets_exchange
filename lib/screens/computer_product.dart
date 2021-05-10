import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/widgets/catagory_productCard.dart';

class ComputerMobileProduct extends StatefulWidget {
  final List<ProductModel> product;
  ComputerMobileProduct({this.product});
  @override
  _ComputerMobileProductState createState() => _ComputerMobileProductState();
}

class _ComputerMobileProductState extends State<ComputerMobileProduct> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> pListfilter = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      filterList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: Constant.background,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: customAppBar(),
      ),
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
                  itemCount: isSearching == true
                      ? pListfilter.length
                      : widget.product.length,
                  itemBuilder: (context, index) {
                    ProductModel prodModel = isSearching == true
                        ? pListfilter[index]
                        : widget.product[index];
                    // ********* Card ********
                    return CatagoryProductCard(prodList: prodModel);
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
                    child: Text('Computers & Mobiles',
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

  //
  filterList() {
    List<ProductModel> _product = [];
    _product.addAll(widget.product);
    if (searchController.text.isNotEmpty) {
      _product.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String productName = element.prodName.toLowerCase();
        return productName.contains(searchTerm);
      });

      setState(() {
        pListfilter = _product;
      });
    } else {
      setState(() {
        searchController.text.isEmpty;
      });
    }
  }
}
