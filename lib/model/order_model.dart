import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel {
  String reqUid;
  String buyerUid;
  String productUid;
  String productImg;
  double productPrice;
  String status;
  Timestamp time;
  String productName;
  String buyerName;
  int quantity;

  OrderModel({
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
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
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
    );
  }
}
