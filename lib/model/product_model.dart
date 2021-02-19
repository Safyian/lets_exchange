import 'package:flutter/material.dart';

class AddProductModel {
  String prodName;
  String prodUid;
  String prodDescription;
  double prodPrice;
  String prodCatagory;
  String prodCoverImg;
  String prodPostBy;
  String prodDate;
  double longitude;
  double latitude;
  double prodQuantity;

  AddProductModel({
    @required this.prodName,
    @required this.prodUid,
    @required this.prodDescription,
    @required this.prodPrice,
    @required this.prodCatagory,
    @required this.longitude,
    @required this.latitude,
    @required this.prodQuantity,
    @required this.prodDate,
    @required this.prodPostBy,
    @required this.prodCoverImg,
  });

  Map<String, dynamic> toMap() {
    return {
      'prodName': prodName,
      'prodUid': prodUid,
      'prodDescription': prodDescription,
      'prodPrice': prodPrice,
      'prodCatagory': prodCatagory,
      'longitude': longitude,
      'latitude': latitude,
      'prodQuantity': prodQuantity,
      'prodDate': prodDate,
      'prodPostBy': prodPostBy,
      'prodCoverImg': prodCoverImg,
    };
  }

  factory AddProductModel.fromMap(Map map) {
    if (map == null) return null;

    return AddProductModel(
      prodName: map['prodName'],
      prodUid: map['prodUid'],
      prodDescription: map['prodDescription'],
      prodPrice: map['prodPrice'],
      prodCatagory: map['prodCatagory'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      prodQuantity: map['prodQuantity'],
      prodDate: map['prodDate'],
      prodPostBy: map['prodPostBy'],
      prodCoverImg: map['prodCoverImg'],
    );
  }
}
