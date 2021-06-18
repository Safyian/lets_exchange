import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductModel {
  String prodName;
  String sellerName;
  String prodUid;
  String prodStatus;
  String prodDescription;
  double prodPrice;
  String prodCatagory;
  String prodBidding;
  String biddingStatus;
  List<String> prodImages;

  List<String> favouriteBy;
  String prodPostBy;
  String prodDate;
  double longitude;
  double latitude;
  int prodQuantity;
  ProductModel({
    @required this.prodName,
    @required this.sellerName,
    @required this.prodUid,
    @required this.prodStatus,
    @required this.prodDescription,
    @required this.prodPrice,
    @required this.prodCatagory,
    @required this.prodImages,
    @required this.prodPostBy,
    @required this.prodDate,
    @required this.longitude,
    @required this.latitude,
    @required this.prodQuantity,
    @required this.favouriteBy,
    @required this.prodBidding,
    @required this.biddingStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'prodName': prodName,
      'sellerName': sellerName,
      'prodUid': prodUid,
      'prodStatus': prodStatus,
      'prodDescription': prodDescription,
      'prodPrice': prodPrice,
      'prodCatagory': prodCatagory,
      'prodImages': prodImages,
      'favouriteBy': favouriteBy,
      'prodPostBy': prodPostBy,
      'prodDate': prodDate,
      'longitude': longitude,
      'latitude': latitude,
      'prodQuantity': prodQuantity,
      'prodBidding': prodBidding,
      'biddingStatus': biddingStatus,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      prodName: map['prodName'],
      sellerName: map['sellerName'],
      prodUid: map['prodUid'],
      prodStatus: map['prodStatus'],
      prodDescription: map['prodDescription'],
      prodPrice: map['prodPrice'],
      prodCatagory: map['prodCatagory'],
      prodImages: List<String>.from(map['prodImages']),
      favouriteBy: List<String>.from(map['favouriteBy']),
      prodPostBy: map['prodPostBy'],
      prodDate: map['prodDate'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      prodQuantity: map['prodQuantity'],
      prodBidding: map['prodBidding'],
      biddingStatus: map['biddingStatus'],
    );
  }
}
