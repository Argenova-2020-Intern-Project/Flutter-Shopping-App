import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Intern/models/User.dart';

class Item {
  String item_uid;
  String author_id;
  String title;
  String explanation;
  String category;
  String location;
  String price;
  Timestamp date;
  DateTime time;
  int views;
  User author;

  Item({this.item_uid,
        this.author_id, 
        this.title, 
        this.explanation,
        this.category, 
        this.location, 
        this.price,
        this.date, 
        this.views
  });
        

  Item.withAuthor({
        this.item_uid,
        this.author_id, 
        this.title, 
        this.explanation,
        this.category, 
        this.location, 
        this.price,
        this.date, 
        this.views,
        this.author
    });
}
