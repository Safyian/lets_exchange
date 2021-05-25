import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatModel {
  String message;
  String sendTo;
  String sendBy;
  Timestamp time;
  ChatModel({
    @required this.message,
    @required this.sendTo,
    @required this.sendBy,
    @required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sendTo': sendTo,
      'sendBy': sendBy,
      'time': time,
    };
  }

  factory ChatModel.fromMap(Map map) {
    return ChatModel(
      message: map['message'],
      sendTo: map['sendTo'],
      sendBy: map['sendBy'],
      time: map['time'],
    );
  }
}
