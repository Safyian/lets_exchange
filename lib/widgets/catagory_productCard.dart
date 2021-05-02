import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';
import 'package:lets_exchange/screens/product_details.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CatagoryProductCard extends StatefulWidget {
  final ProductModel prodList;

  CatagoryProductCard({@required this.prodList});

  @override
  _CatagoryProductCardState createState() => _CatagoryProductCardState();
}

class _CatagoryProductCardState extends State<CatagoryProductCard> {
  bool tagFavourite;
  @override
  void initState() {
    super.initState();
    tagFavourite =
        widget.prodList.favouriteBy.contains(Constant.userId) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(productDetail: widget.prodList));
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
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
                    child: Image.network(widget.prodList.prodImages[0],
                        fit: BoxFit.cover),
                  ),
                  // Favourite icon
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tagFavourite = !tagFavourite;
                          });
                          addtoFavourite(uid: widget.prodList.prodUid);
                        },
                        child: Container(
                          child: Icon(
                            tagFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: tagFavourite ? Colors.red : Colors.white,
                            size: Get.width * 0.08,
                          ),
                        ),
                      ),
                    ),
                  )
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
                widget.prodList.prodName,
                style: GoogleFonts.roboto(
                    color: Colors.black, fontSize: Get.width * 0.035),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            // ********* Product Price Text ********
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${Services().formateMoney(widget.prodList.prodPrice)}',
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
      ),
    );
  }

  addtoFavourite({@required String uid}) async {
    if (tagFavourite == true) {
      await FirebaseFirestore.instance.collection('Products').doc(uid).set({
        'favouriteBy': FieldValue.arrayUnion([Constant.userId])
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Constant.userId)
          .collection('favourites')
          .doc(uid)
          .set({'prodUid': uid}, SetOptions(merge: true));
    } else if (tagFavourite == false) {
      await FirebaseFirestore.instance.collection('Products').doc(uid).update(
        {
          'favouriteBy': FieldValue.arrayRemove([Constant.userId])
        },
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Constant.userId)
          .collection('favourites')
          .doc(uid)
          .delete();
    }
  }
}
