import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel prodList;
  final Function onTap;
  final bool delete;

  ProductCard(
      {@required this.prodList, @required this.onTap, @required this.delete});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool tagFavourite;

  @override
  Widget build(BuildContext context) {
    tagFavourite =
        widget.prodList.favouriteBy.contains(Constant.userId) ? true : false;
    return GestureDetector(
      onTap: widget.onTap,
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
                  widget.prodList.prodPostBy == Constant.userId
                      ? widget.delete == true
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: 'DELETE',
                                      middleText: 'Are you sure?',
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            deleteProduct();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Constant.btnWidgetColor),
                                          child: Text('YES',
                                              style: TextStyle(
                                                  fontSize: Get.width * 0.04,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Constant.btnWidgetColor),
                                          child: Text('NO',
                                              style: TextStyle(
                                                  fontSize: Get.width * 0.04,
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    );
                                  },
                                  child: Container(
                                    width: Get.width * 0.08,
                                    height: Get.width * 0.08,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.delete,
                                      // color: Colors.red,
                                      size: Get.width * 0.055,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'Add to Bidding',
                                    middleText: 'Are you sure?',
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          addToBidding(
                                              prodUid: widget.prodList.prodUid);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Constant.btnWidgetColor),
                                        child: Text('YES',
                                            style: TextStyle(
                                                fontSize: Get.width * 0.04,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Constant.btnWidgetColor),
                                        child: Text('NO',
                                            style: TextStyle(
                                                fontSize: Get.width * 0.04,
                                                fontWeight: FontWeight.w600)),
                                      )
                                    ],
                                  );
                                },
                                child: Container(
                                  width: Get.width * 0.12,
                                  height: Get.width * 0.12,
                                  decoration: BoxDecoration(
                                      // color: Colors.black,
                                      color: Constant.btnWidgetColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12))),
                                  child: Icon(
                                    Icons.addchart_rounded,
                                    color: Colors.white,
                                    size: Get.width * 0.055,
                                  ),
                                ),
                              ),
                            )
                      : Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                tagFavourite = !tagFavourite;
                              });
                              addtoFavourite(uid: widget.prodList.prodUid);
                            },
                            child: Container(
                              width: Get.width * 0.1,
                              height: Get.width * 0.1,
                              decoration: BoxDecoration(
                                  // color: Colors.black,
                                  color: Constant.btnWidgetColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12))),
                              child: Icon(
                                tagFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: tagFavourite ? Colors.red : Colors.white,
                                size: Get.width * 0.06,
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

// Add to bid method
  Future<void> addToBidding({String prodUid}) async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(prodUid)
        .collection('Biddings')
        .doc()
        .set({'status': 'pending'});
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.prodList.prodUid)
        .update({
      'prodStatus': 'bidding',
      'prodBidding': 'true',
      'biddingStatus': 'true'
    }).then((value) => Get.back());
  }

  Future<void> deleteProduct() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.prodList.prodUid)
        .delete()
        .then((value) => Get.back());
  }
}
