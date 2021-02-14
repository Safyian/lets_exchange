import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _prodName;
  TextEditingController _prodDescription;
  TextEditingController _prodPrice;

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding customInputField(
      {TextEditingController controller,
      String label,
      IconData preIcon,
      TextInputType keyType}) {
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
