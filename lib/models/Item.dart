import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Intern/models/User.dart';

class Item {
  String item_uid;
  String author_id;
  String title;
  String explanation;
  String category;
  String price;
  Timestamp date;
  DateTime time;
  User author;
  String img_url;
  double latitude;
  double longitude;

  Item(
      {this.item_uid,
      this.author_id,
      this.title,
      this.explanation,
      this.category,
      this.price,
      this.date,
      this.img_url,
      this.latitude,
      this.longitude});

  Item.withAuthor(
      {this.item_uid,
      this.author_id,
      this.title,
      this.explanation,
      this.category,
      this.price,
      this.date,
      this.author,
      this.img_url,
      this.latitude,
      this.longitude});
}
