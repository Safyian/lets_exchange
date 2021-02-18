import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/authentication.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lets_exchange/screens/pick_address_from_map.dart';
import 'package:location/location.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _prodName;
  TextEditingController _prodDescription;
  TextEditingController _prodPrice;
  List<double> address = [0.0, 0.0];
  List catagoryList = [
    'Kitchen Accessories',
    'Home Accessories',
    'Computers & Mobiles',
    'Games',
    'Audio & Video',
    'Other'
  ];
  String catagory;
  double _value = 1.0;
  int quantity = 1;

  @override
  void initState() {
    _prodDescription = TextEditingController();
    _prodName = TextEditingController();
    _prodPrice = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 10),
        child: customAppBar(),
      ),

      // ******* Body Start *******
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.025,
                ),
                // ********* Add Cover Image ******
                Container(
                  width: Get.width * 0.4,
                  height: Get.height * 0.18,
                  decoration: customDecoration.copyWith(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 35.0,
                        color: Constant.btnWidgetColor,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        'Add Cover',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                // ***** Add More Image ******
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 8.0),
                  child: Text(
                    'Add more Pictures(optional)',
                    style: TextStyle(
                        // fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ****** 1nd Image ********
                    Container(
                      width: Get.width * 0.2,
                      height: Get.height * 0.08,
                      decoration: customDecoration2.copyWith(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Icon(
                        Icons.add,
                        // size: 35.0,
                        color: Colors.grey[200],
                      ),
                    ),

                    SizedBox(
                      width: Get.width * 0.06,
                    ),
                    // ********* 2rd Image *********
                    Container(
                      width: Get.width * 0.2,
                      height: Get.height * 0.08,
                      decoration: customDecoration2.copyWith(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Icon(
                        Icons.add,
                        // size: 35.0,
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                ),

                // ********* Text Input Fields **********
                SizedBox(
                  height: Get.height * 0.012,
                ),
                // ********* Product Name **********
                customInputField(
                  controller: _prodName,
                  label: 'Product Name',
                  preIcon: Icons.label_important,
                  keyType: TextInputType.text,
                ),
                // ********* Product Description **********
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: (Get.height / 100) * 30,
                    // child: customInputField(
                    //   controller: _prodDescription,
                    //   label: 'Product Description',
                    //   preIcon: Icons.description,
                    //   keyType: TextInputType.text,
                    // ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _prodDescription,
                        decoration: InputDecoration(
                          hintText: 'Product Description ...',
                          prefixIcon: Icon(Icons.description,
                              color: Constant.btnWidgetColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        ),
                        // decoration: inputDecoration.copyWith(
                        //     labelText: 'Product Description',
                        //     prefixIcon: Icon(
                        //       Icons.description,
                        //       color: Constant.btnWidgetColor
                        //     )),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter a Password';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,

                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                // ********* Product Name **********
                customInputField(
                  controller: _prodPrice,
                  label: 'Product Price',
                  preIcon: Ionicons.md_pricetag,
                  keyType: TextInputType.number,
                ),
                // ******** Catagory DropDown ******
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 2.5, 25, 2.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      // color: Colors.white,
                    ),
                    child: DropdownButton(
                      value: catagory,
                      onChanged: (value) {
                        setState(() {
                          catagory = value;
                        });
                      },
                      isExpanded: true,
                      underline: Container(),
                      hint: Text(
                        'Select a Catagory',
                        style: TextStyle(color: Colors.black54),
                      ),
                      items: catagoryList.map((religionValue) {
                        return DropdownMenuItem(
                          value: religionValue,
                          child: Text(religionValue),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ********** Select From Map Button *********
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _AddressBtn(
                    text: 'Select your Location',
                    onTap: () async {
                      bool locationStatus = await Location().serviceEnabled();
                      if (locationStatus) {
                        address = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PickAddressFromMap()));
                      } else {
                        Authentication.showError(
                            'Error', 'Please turn on location');
                      }

                      if (mounted) {
                        setState(() {
                          // long.text = address[1].toString();
                          // lat.text = address[0].toString();
                        });
                      }

                      // if (address != null) {
                      //   setState(() {
                      //     businessAddress = address;
                      //   });
                      //   await helper.saveAddress(address);
                      // }
                    },
                  ),
                ),

                // ********* Quantity Slider ********
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Quantity: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: (Get.width / 100) * 4.5),
                      ),
                      // ******** Decrement *******
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            quantity > 1 ? quantity-- : quantity = 1;

                            setState(() {
                              print(quantity);
                            });
                          },
                          child: quantityContainer(MaterialIcons.remove),
                        ),
                      ),

                      // ********* Quantity value *******
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: (Get.width / 100) * 20.0,
                          height: (Get.width / 100) * 16.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border:
                                  Border.all(color: Constant.btnWidgetColor)),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(fontSize: Get.width * 0.045),
                          ),
                        ),
                      ),
                      // ******** increament *******
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            print(quantity);
                            quantity++;
                            print(quantity);
                            setState(() {});
                          },
                          child: quantityContainer(
                            MaterialIcons.add,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // *********** Post Add Button *******
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width * 0.8,
                    height: (Get.height / 100) * 6,
                    child: RaisedButton(
                      onPressed: () {},
                      color: Constant.btnWidgetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'POST AD',
                        style: TextStyle(
                            color: Colors.white, fontSize: Get.width * 0.05),
                      ),
                    ),
                  ),
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
                    child: Text('Add Product',
                        style: GoogleFonts.pacifico(
                          color: Constant.iconColor,
                          fontSize: Get.width * 0.055,
                          // fontWeight: FontWeight.bold,
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

  Container quantityContainer(IconData icon) {
    return Container(
      width: (Get.width / 100) * 12.0,
      height: (Get.width / 100) * 12.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  // ******** TextFormField *******
  Padding customInputField({
    TextEditingController controller,
    String label,
    IconData preIcon,
    TextInputType keyType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: inputDecoration.copyWith(
            labelText: label,
            prefixIcon: Icon(preIcon, color: Constant.btnWidgetColor)),
        validator: (val) {
          if (val.isEmpty) {
            return 'Please enter a Password';
          } else
            return null;
        },
        keyboardType: keyType,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

// Button Select your location
class _AddressBtn extends StatelessWidget {
  final String text;
  final Function onTap;
  const _AddressBtn({
    @required this.text,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 3,
          //     color: Colors.grey,
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MaterialIcons.location_on,
              color: Colors.red[700],
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
