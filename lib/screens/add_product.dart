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
      appBar: AppBar(
        title: Text(
          'Add Products',
          style: GoogleFonts.permanentMarker(fontSize: Get.width * 0.06),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: customDecoration,
        ),
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
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 35.0,
                        color: Colors.grey[200],
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        'Add Cover',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                customInputField(
                  controller: _prodDescription,
                  label: 'Product Description',
                  preIcon: Icons.description,
                  keyType: TextInputType.text,
                ),
                // ********* Product Name **********
                customInputField(
                  controller: _prodPrice,
                  label: 'Product Price',
                  preIcon: Ionicons.md_pricetag,
                  keyType: TextInputType.number,
                ),
                // ******** Catagory ******
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 2.5, 25, 2.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white,
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

                // ********** Select From MAp Button *********
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30,
                      right: MediaQuery.of(context).size.width / 30,
                      top: MediaQuery.of(context).size.width / 40),
                  child: _AddressBtn(
                    text: 'Select from Map',
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
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  ),
                  child: Slider(
                    value: _value,
                    min: 1.0,
                    max: 100.0,
                    divisions: 100,
                    label: '${_value.toInt()}',
                    onChanged: (value) {
                      setState(
                        () {
                          _value = value;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
            prefixIcon: Icon(
              preIcon,
              color: Colors.blue,
            )),
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

// Button Select on Map
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
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.grey,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
