import 'dart:convert';

import 'package:flutter/material.dart';

class CatagoryModel {
  String catagory;
  String image;
  CatagoryModel({
    @required this.catagory,
    @required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'catagory': catagory,
      'image': image,
    };
  }

  factory CatagoryModel.fromMap(Map map) {
    return CatagoryModel(
      catagory: map['catagory'],
      image: map['image'],
    );
  }
}
