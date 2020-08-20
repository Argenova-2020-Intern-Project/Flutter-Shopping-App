import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/services/item-validator.dart';
import 'package:Intern/views/home/item-list.dart';

class HomePage extends StatefulWidget {
  static const String route_id = "/home";

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with ItemValidationMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController itemCtrl = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  List<Item> itemList = List();
  FirebaseUser user;
  final int maxItemFromScreen = 10;

  Future getItems() async {
    user ??= await AuthService().getCurrentUser();
    return databaseService.items(limit: 5, isFirst: true);
  }

  @override
  void dispose() {
    itemCtrl.dispose();
    super.dispose();
  }

  void getMoreData() async {
    var newList =
        await databaseService.items(limit: maxItemFromScreen, isFirst: false);
    setState(() {
      itemList.addAll(newList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  getMoreData();
                },
                child: Icon(
                  Icons.refresh,
                )),
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: getItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      itemList = snapshot.data;
                      return ItemList(user: user, itemList: itemList);
                      //return buildPostList();
                    }
                  },
                ),
              )
            ],
          )),
    );
  }
}
