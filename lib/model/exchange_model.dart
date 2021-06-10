import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExchangeModel {
  String reqUid;
  String buyerUid;
  String productUid;
  String productImg;
  String exchangeProductImg;
  double productPrice;
  String status;
  Timestamp time;
  String productName;
  String buyerName;
  String exchangeProductName;
  String exchangeProductDetails;
  int quantity;

  ExchangeModel({
    @required this.reqUid,
    @required this.buyerUid,
    @required this.productUid,
    @required this.productImg,
    @required this.productPrice,
    @required this.status,
    @required this.time,
    @required this.productName,
    @required this.quantity,
    @required this.buyerName,
    @required this.exchangeProductDetails,
    @required this.exchangeProductImg,
    @required this.exchangeProductName,
  });

  Map<String, dynamic> toMap() {
    return {
      'reqUid': reqUid,
      'buyerUid': buyerUid,
      'productUid': productUid,
      'productImg': productImg,
      'productPrice': productPrice,
      'status': status,
      'time': time,
      'productName': productName,
      'quantity': quantity,
      'buyerName': buyerName,
      'exchangeProductDetails': exchangeProductDetails,
      'exchangeProductImg': exchangeProductImg,
      'exchangeProductName': exchangeProductName,
    };
  }

  factory ExchangeModel.fromMap(Map<String, dynamic> map) {
    return ExchangeModel(
      reqUid: map['reqUid'],
      buyerUid: map['buyerUid'],
      productUid: map['productUid'],
      productImg: map['productImg'],
      productPrice: map['productPrice'],
      status: map['status'],
      time: map['time'],
      productName: map['productName'],
      quantity: map['quantity'],
      buyerName: map['buyerName'],
      exchangeProductDetails: map['exchangeProductDetails'],
      exchangeProductImg: map['exchangeProductImg'],
      exchangeProductName: map['exchangeProductName'],
    );
  }
}
