import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/shared/ItemTile.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:Intern/views/bottom-nav-bar.dart';

class ItemList extends StatefulWidget {
  final List<Item> itemList;
  final FirebaseUser user;

  ItemList({this.itemList, this.user});

  @override
  State createState() => _ItemList();
}

class _ItemList extends State<ItemList> {
  DatabaseService databaseService = DatabaseService();
  final int maxItemFromScreen = 10;

  Future onDeleteItem(Item item) async {
    var result = await databaseService.deleteItem(item);
    if (result == null) {
      Toast.show('There is something wrong about deleting your item', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    } else {
      setState(() {
        widget.itemList.remove(item);
        FocusScope.of(context).unfocus();
        Toast.show('Your item successfully deleted', context,
            duration: Toast.LENGTH_LONG,
            backgroundColor: ThemeData.dark().dialogBackgroundColor);
      });
    }
  }

  Future onUpdateItem(Item item) async {
    var result = await databaseService.updateItem(item);
    if (result == null) {
      Toast.show('There is something wrong about updating your item', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    } else {
      Toast.show('Your item successfully updated', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    }
  }

  void updateItemDialog({BuildContext context, Item item}) {
    TextEditingController updateItemTitle = TextEditingController();
    TextEditingController updateItemExplanation = TextEditingController();
    TextEditingController updateItemCategory = TextEditingController();
    TextEditingController updateItemPrice = TextEditingController();
    TextEditingController updateItemLatitude = TextEditingController();
    TextEditingController updateItemLongitude = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      TextField(
                        controller: updateItemTitle,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old Title: " + item.title),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: updateItemExplanation,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old Explanation: " + item.explanation),
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField<String>(
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) {
                          setState(() {
                            updateItemCategory.text = value;
                          });
                        },
                        hint: Text("Old category: " + item.category),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: updateItemLatitude,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Old latitude: ${item.latitude}',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: updateItemLongitude,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Old longitude: ${item.longitude}',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: updateItemPrice,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old Price: " + item.price),
                      ),
                    ],
                  )),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    if (updateItemTitle.text.isEmpty &&
                        updateItemExplanation.text.isEmpty &&
                        updateItemCategory.text.isEmpty &&
                        updateItemPrice.text.isEmpty &&
                        updateItemLatitude.text.isEmpty &&
                        updateItemLongitude.text.isEmpty) {
                      Toast.show("Please fill at least one box", context,
                          gravity: Toast.BOTTOM);
                    } else {
                      item.title = updateItemTitle.text.isNotEmpty
                          ? updateItemTitle.text
                          : null;
                      item.explanation = updateItemExplanation.text.isNotEmpty
                          ? updateItemExplanation.text
                          : null;
                      item.category = updateItemCategory.text.isNotEmpty
                          ? updateItemCategory.text
                          : null;
                      item.price = updateItemPrice.text.isNotEmpty
                          ? updateItemPrice.text
                          : null;
                      item.latitude = updateItemLatitude.text.isNotEmpty
                          ? double.parse(updateItemLatitude.text.toString())
                          : null;
                      item.longitude = updateItemLongitude.text.isNotEmpty
                          ? double.parse(updateItemLongitude.text.toString())
                          : null;
                      updateItemTitle.clear();
                      updateItemExplanation.clear();
                      updateItemPrice.clear();
                      updateItemLatitude.clear();
                      updateItemLongitude.clear();
                      await onUpdateItem(item);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()),
                      );
                    }
                  },
                  child: Text("Update"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: widget.itemList.length,
      itemBuilder: (context, index) {
        return ItemTile(
            context: context,
            isAuthor: widget.user.uid == widget.itemList[index].author.uid,
            item: widget.itemList[index],
            delete: () => onDeleteItem(widget.itemList[index]),
            update: () => updateItemDialog(
                  context: context,
                  item: widget.itemList[index],
                ));
      },
    );
  }
}
