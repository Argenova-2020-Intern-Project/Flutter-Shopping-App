import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String uid;
  String senderId;
  String content;
  Timestamp time;

  Message({this.uid, this.senderId, this.content, this.time});
}