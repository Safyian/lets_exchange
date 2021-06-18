import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_exchange/auth_helper/services.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/model/product_model.dart';

class BidCard extends StatefulWidget {
  final ProductModel prodList;
  final Function onTap;
  final bool delete;

  BidCard(
      {@required this.prodList, @required this.onTap, @required this.delete});

  @override
  _BidCardState createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  bool tagFavourite;
  List bidInfoList = [];

  @override
  void initState() {
    biddingInfo();
    super.initState();
  }

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
                                      title: 'Remove from Bidding',
                                      middleText: 'Are you sure?',
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            removeFromBidding();
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
                                      Icons.remove_circle,
                                      // color: Colors.red,
                                      size: Get.width * 0.05,
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
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('Products')
                                              .doc(widget.prodList.prodUid)
                                              .update({
                                            'prodStatus': 'bidding'
                                          }).then((value) => Get.back());
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
                      : SizedBox(),
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
            Row(
              children: [
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    widget.prodList.biddingStatus == 'true' ? 'ACTIVE' : 'END',
                    style: GoogleFonts.roboto(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                        fontSize: Get.width * 0.03),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            // Total Bids Text
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                bidInfoList.length == null
                    ? 'Total Bids: 0 Bid'
                    : 'Total Bids: ${bidInfoList.length}',
                style: GoogleFonts.roboto(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.035),
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
  // geting total bids amount

  Future<void> biddingInfo() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.prodList.prodUid)
        .collection('Biddings')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .listen((event) {
      bidInfoList.clear();
      event.docs.forEach((element) {
        bidInfoList.add(element.data());
      });
      setState(() {});
      print('info ==== ${bidInfoList.length}');
    });
  }

  Future<void> removeFromBidding() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.prodList.prodUid)
        .update({
      'prodBidding': 'false',
      'prodStatus': 'pending',
      'biddingStatus': 'end'
    }).then((value) => Get.back());
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.prodList.prodUid)
        .collection('Biddings')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.prodList.prodUid)
            .collection('Biddings')
            .doc(element.id)
            .delete();
      });
    });
  }
}
