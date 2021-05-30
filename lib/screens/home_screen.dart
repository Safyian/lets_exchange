import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/catagory_model.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/add_product.dart';
import 'package:lets_exchange/screens/audiovideo_product.dart';
import 'package:lets_exchange/screens/computer_product.dart';
import 'package:lets_exchange/screens/game_product.dart';
import 'package:lets_exchange/screens/home_product.dart';
import 'package:lets_exchange/screens/kitchen_products.dart';
import 'package:lets_exchange/screens/product_details.dart';
import 'package:lets_exchange/widgets/drawer.dart';
import 'package:lets_exchange/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ProductModel> _pList = [];
  List<ProductModel> pListfilter = [];
  List<ProductModel> _computerMobList = [];
  List<ProductModel> _kitchenList = [];
  List<ProductModel> _homeList = [];
  List<ProductModel> _gameList = [];
  List<ProductModel> _avList = [];
  List<ProductModel> _otherList = [];
  bool search = false;
  TextEditingController searchController = TextEditingController();
  List<CatagoryModel> catagoryList = [
    CatagoryModel(catagory: 'Kitchen', image: 'assets/kitchen.png'),
    CatagoryModel(catagory: 'Home', image: 'assets/home.png'),
    CatagoryModel(
        catagory: 'Computers & Mobiles', image: 'assets/computer.png'),
    CatagoryModel(catagory: 'Games', image: 'assets/console.png'),
    CatagoryModel(catagory: 'Audio & Video', image: 'assets/audio.png'),
  ];

  @override
  void initState() {
    super.initState();
    getProducts();
    searchController.addListener(() {
      filterList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    print('object = ${_pList.length}');
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
                          onTap: () {
                            search = !search;
                            setState(() {});
                          },
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
                              favouriteBy: null);
                          Get.to(AddProduct(productModel: productModel));
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            color: Constant.background,
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                //************ Search Bar ************
                search
                    ? Container(
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
                                borderSide:
                                    BorderSide(color: Colors.grey[200])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: Colors.grey[200])),
                            hintText: 'Search',
                          ),
                        ),
                      )
                    : SizedBox(),
                search
                    ? SizedBox(
                        height: Get.height * 0.01,
                      )
                    : SizedBox(),

                // ******** Catagories Icon List  *******
                Container(
                  width: Get.width,
                  height: 100,
                  // height: Get.height * 0.12,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: catagoryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0)
                            Get.to(KitchenProduct(
                              product: _kitchenList,
                            ));
                          if (index == 1)
                            Get.to(HomeProduct(
                              product: _homeList,
                            ));
                          if (index == 2)
                            Get.to(ComputerMobileProduct(
                              product: _computerMobList,
                            ));
                          if (index == 3)
                            Get.to(GameProduct(
                              product: _gameList,
                            ));
                          if (index == 4)
                            Get.to(AudioVideoProduct(
                              product: _avList,
                            ));
                        },
                        child: Container(
                          width: Get.width * 0.235,
                          child: Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    child:
                                        Image.asset(catagoryList[index].image),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Center(
                                    child: Text(
                                      catagoryList[index].catagory,
                                      style: GoogleFonts.roboto(
                                          fontSize: Get.width * 0.028,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                      isSearching == true ? pListfilter.length : _pList.length,
                  itemBuilder: (context, index) {
                    ProductModel prodModel = isSearching == true
                        ? pListfilter[index]
                        : _pList[index];
                    // ********* Card ********
                    return ProductCard(
                      // prodList: _pList[index],
                      prodList: prodModel,
                      onTap: () {
                        Get.to(
                          // ProductDetailsScreen(productDetail: _pList[index]),
                          ProductDetailsScreen(productDetail: prodModel),
                        );
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

  // ********** Getting Products ********
  Future<void> getProducts() async {
    // ******** All Products *******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) async {
      if (value.docs != null) {
        _pList.clear();
        value.docs.forEach((element) {
          _pList.add(ProductModel.fromMap(element.data()));
        });
        setState(() {});
      }
    });
    // ******** Computer & Mob List getting*******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodCatagory', isEqualTo: 'Computers & Mobiles')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _computerMobList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _computerMobList.add(ProductModel.fromMap(element.data()));
        });

        setState(() {});
      }
    });
    // ******** Game List *******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodCatagory', isEqualTo: 'Games')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _gameList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _gameList.add(ProductModel.fromMap(element.data()));
          setState(() {});
        });

        setState(() {});
      }
    });
    // ******** Home Acc List *******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodCatagory', isEqualTo: 'Home Accessories')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _homeList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _homeList.add(ProductModel.fromMap(element.data()));
        });

        setState(() {});
      }
    });

// ******** Kitchen Accessories *******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodCatagory', isEqualTo: 'Kitchen Accessories')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _kitchenList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _kitchenList.add(ProductModel.fromMap(element.data()));
        });

        setState(() {});
      }
    });
    // ******** Audio & Video List getting *******
    await FirebaseFirestore.instance
        .collection('Products')
        .where('prodCatagory', isEqualTo: 'Audio & Video')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _avList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _avList.add(ProductModel.fromMap(element.data()));
        });

        setState(() {});
      }
      print('set = $_avList');
    });
    // ******** others List *******
    await FirebaseFirestore.instance
        .collection('Procucts')
        .where('prodCatagory', isEqualTo: 'Other')
        .where('prodStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((value) {
      if (value.docs != null) {
        _otherList.clear();
        value.docs.forEach((element) {
          print('id = ${element.id}');
          _otherList.add(ProductModel.fromMap(element.data()));
        });

        setState(() {});
      }
    });
  }

  //
  //
  filterList() {
    List<ProductModel> _product = [];
    _product.addAll(_pList);
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
