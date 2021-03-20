import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/add_product.dart';
import 'package:lets_exchange/screens/product_details.dart';
import 'package:lets_exchange/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<AddProductModel> _pList = List<AddProductModel>();

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    _pList.sort(
        (a, b) => a.prodName.toLowerCase().compareTo(b.prodName.toLowerCase()));
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: AppBar(
          elevation: 0.0,
          leading: Container(),
          flexibleSpace: Container(
            color: Constant.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: <Widget>[
                      //
                      //
                      //********* Drawer Menu  **********
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState.openDrawer(),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Constant.iconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      Spacer(),
                      //
                      //********* Notifications Icon *******/
                      Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.06),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            FontAwesome5.bell,
                            color: Constant.iconColor,
                            size: 24,
                          ),
                        ),
                      ),

                      //
                      // *********** Search Icons *********
                      Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.06),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Ionicons.md_search,
                            color: Constant.iconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      //
                      // ********* POST Button *********
                      GestureDetector(
                        onTap: () {
                          Get.to(AddProduct());
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
                              'POST',
                              style: TextStyle(
                                fontSize: 14,
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
      ),
      backgroundColor: Constant.background,
      body: SingleChildScrollView(
        child: Container(
          color: Constant.background,
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  //************ Search Bar ************
                  Container(
                    width: Get.width * 0.8,
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
                    width: Get.width * 0.01,
                  ),
                  // *********** Filter Button *******
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState.openDrawer(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Ionicons.ios_color_filter,
                        color: Constant.iconColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                itemCount: _pList.length,
                itemBuilder: (context, index) {
                  // ********* Card ********
                  return Card(
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
                                child: Image.network(_pList[index].prodCoverImg,
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
                            _pList[index].prodName,
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
                            '${formateMoney(_pList[index].prodPrice)}',
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
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
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

// ******** Getting User Info *******
  getUserInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constant.userId)
        .get()
        .then((value) {
      print('value = ${value.data()['image']}');

      Constant.userEmail = value.data()['email'];
      Constant.userName = value.data()['name'];
      Constant.userImage = value.data()['image'];
    });
  }

  // ********** Getting Products ********
  Future<void> getProducts() async {
    await FirebaseFirestore.instance
        .collection('Computers & Mobiles')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _pList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _pList.add(AddProductModel.fromMap(element.data()));
        });
        setState(() {});
      }
    });
  }

  // ******** Money Formattor *********
  formateMoney(double amount) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: 'Rs.',
        fractionDigits: 0,
      ),
    );
    return fmf.output.symbolOnLeft;
  }
}
