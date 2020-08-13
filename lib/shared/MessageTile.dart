import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  bool isSelf = true;
  String msg = "";
  Timestamp timestamp;

  MessageTile({this.isSelf, this.msg, this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateTime dt = timestamp.toDate();
    String time = DateFormat("kk:mm").format(dt);
    return Container(
      alignment: isSelf ? Alignment.topRight : Alignment.bottomLeft,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.20,
          maxWidth: MediaQuery.of(context).size.width * 0.70),
        padding:
        EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: isSelf ? Colors.blue : Colors.blueGrey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(isSelf ? 10 : 0),
              topRight: Radius.circular(isSelf ? 0 : 10),
            )
        ),
        
        child: Column(
          crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(msg, style: TextStyle(fontSize: 14)),
            Text(time, style: TextStyle(fontSize: 10, color: Colors.white70))
          ],
        ),
        
      ),
    );
  }
}