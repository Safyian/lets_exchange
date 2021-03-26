import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddProductModel {
  String prodName;
  String sellerName;
  String prodUid;
  String prodStatus;
  String prodDescription;
  double prodPrice;
  String prodCatagory;
  List<String> prodImages;
  String prodPostBy;
  String prodDate;
  double longitude;
  double latitude;
  int prodQuantity;
  AddProductModel({
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
      'prodPostBy': prodPostBy,
      'prodDate': prodDate,
      'longitude': longitude,
      'latitude': latitude,
      'prodQuantity': prodQuantity,
    };
  }

  factory AddProductModel.fromMap(Map<String, dynamic> map) {
    return AddProductModel(
      prodName: map['prodName'],
      sellerName: map['sellerName'],
      prodUid: map['prodUid'],
      prodStatus: map['prodStatus'],
      prodDescription: map['prodDescription'],
      prodPrice: map['prodPrice'],
      prodCatagory: map['prodCatagory'],
      prodImages: List<String>.from(map['prodImages']),
      prodPostBy: map['prodPostBy'],
      prodDate: map['prodDate'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      prodQuantity: map['prodQuantity'],
    );
  }
}
