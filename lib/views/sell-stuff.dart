import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/services/item-validator.dart';
import 'package:toast/toast.dart';
import 'package:Intern/main.dart' as ref;

class SellStuff extends StatefulWidget {
  static const String route_id = "/home";

  @override
  State<StatefulWidget> createState() {
    return _SellStuff();
  }
}

class _SellStuff extends State<SellStuff> with ItemValidationMixin {
  final formKey = GlobalKey<FormState>();
  bool validateTitle = false;
  bool validateExplanation = false;
  bool validateCategory = false;
  bool validateLocation = false;
  bool validatePrice = false;
  final TextEditingController itemTitle = TextEditingController();
  final TextEditingController itemExplanation = TextEditingController();
  String itemCategory;
  final TextEditingController itemLocation = TextEditingController();
  final TextEditingController itemPrice = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  List<Item> itemList = List();
  FirebaseUser user;

  Future getItems() async {
    user ??= await AuthService().getCurrentUser();
    return databaseService.items(limit: 5, isFirst: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sell Stuff'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: TextField(
                          controller: itemTitle,
                          style: ref.textStyle,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Enter the title of your item",
                            errorText:
                                validateTitle ? 'Title can\'t be empty!' : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: TextField(
                          controller: itemExplanation,
                          style: ref.textStyle,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText:
                                "Enter some explanations about your item",
                            errorText: validateExplanation
                                ? 'Explanations can\'t be empty!'
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: DropdownButtonFormField<String>(
                          items: [
                            DropdownMenuItem<String>(
                              value: "Electronics",
                              child: Text(
                                "Electronics",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Sports",
                              child: Text(
                                "Sports",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Cars",
                              child: Text(
                                "Cars",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Gaming",
                              child: Text(
                                "Gaming",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Movies, Books and Music",
                              child: Text(
                                "Movies, Books and Music",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Housing",
                              child: Text(
                                "Housing",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Other",
                              child: Text(
                                "Other",
                              ),
                            ),
                          ],
                          style: ref.textStyle.copyWith(color: Colors.grey),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            itemCategory = value;
                          },
                          hint: Text("Please select the category of your item"),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: TextField(
                          controller: itemLocation,
                          style: ref.textStyle,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Enter the location of your item",
                            errorText: validateLocation
                                ? 'Location can\'t be empty!'
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: TextField(
                          controller: itemPrice,
                          style: ref.textStyle,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Enter the price of your item",
                            errorText:
                                validatePrice ? 'Price can\'t be empty!' : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: ref.buttonColor,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async {
                            setState(() {
                              itemTitle.text.isEmpty
                                  ? validateTitle = true
                                  : validateTitle = false;
                              itemExplanation.text.isEmpty
                                  ? validateExplanation = true
                                  : validateExplanation = false;
                              itemCategory.isEmpty
                                  ? validateCategory = true
                                  : validateCategory = false;
                              itemLocation.text.isEmpty
                                  ? validateLocation = true
                                  : validateLocation = false;
                              itemPrice.text.isEmpty
                                  ? validatePrice = true
                                  : validatePrice = false;
                            });
                            if (itemTitle.text.isNotEmpty &&
                                itemExplanation.text.isNotEmpty &&
                                (itemCategory?.isNotEmpty ?? true) &&
                                itemLocation.text.isNotEmpty &&
                                itemPrice.text.isNotEmpty) {
                              String title = itemTitle.text;
                              String explanation = itemExplanation.text;
                              String category = itemCategory;
                              String location = itemLocation.text;
                              String price = itemPrice.text;
                              itemTitle.clear();
                              itemExplanation.clear();
                              itemLocation.clear();
                              itemPrice.clear();

                              user ??= await AuthService().getCurrentUser();
                              Item item = Item(
                                  title: title,
                                  explanation: explanation,
                                  category: category,
                                  location: location,
                                  price: price,
                                  author_id: user.uid,
                                  date: Timestamp.now());
                              databaseService.insertItem(item).then((value) {
                                setState(() {
                                  itemList.add(item);
                                });
                                Toast.show(
                                    'Your item posted successfully!', context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              });
                            }
                          },
                          child: Text("Post your item",
                              textAlign: TextAlign.center,
                              style: ref.buttonTextStyle),
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
