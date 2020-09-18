import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:toast/toast.dart';
import 'package:Intern/main.dart' as ref;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:Intern/models/Location.dart';
import 'package:Intern/views/bottom-nav-bar.dart';

class SellStuff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SellStuff();
  }
}

class _SellStuff extends State<SellStuff> {
  final formKey = GlobalKey<FormState>();
  File _image;
  List<Item> itemList = List();
  FirebaseUser user;
  bool validateTitle = false;
  bool validateExplanation = false;
  bool validateCategory = false;
  bool validatePrice = false;
  bool validateLatitude = false;
  bool validateLongitude = false;
  bool currLocation = false;
  bool isLoading = false;
  final TextEditingController itemTitle = TextEditingController();
  final TextEditingController itemExplanation = TextEditingController();
  final TextEditingController itemCategory = TextEditingController();
  final TextEditingController itemPrice = TextEditingController();
  final TextEditingController itemLatitude = TextEditingController();
  final TextEditingController itemLongitude = TextEditingController();
  final DatabaseService databaseService = DatabaseService();

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future postItem(String title, String explanation, String category,
      String price, double latitude, double longitude) async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('item-photos/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    user ??= await AuthService().getCurrentUser();
    storageReference.getDownloadURL().then((fileURL) {
      Item item = Item(
          title: title,
          explanation: explanation,
          category: category,
          price: price,
          author_id: user.uid,
          date: Timestamp.now(),
          img_url: fileURL,
          latitude: latitude,
          longitude: longitude);
      databaseService.insertItem(item).then((value) {
        setState(() {
          itemList.add(item);
          isLoading = false;
        });
        Toast.show('Your item posted successfully!', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sell Stuff', style: ref.appbarTextStyle),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: TextField(
                                controller: itemTitle,
                                style: ref.textStyle,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Enter the title of your item",
                                  errorText: validateTitle
                                      ? 'Title can\'t be empty!'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
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
                          SizedBox(height: 10.0),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
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
                                style:
                                    ref.textStyle.copyWith(color: Colors.grey),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    itemCategory.text = value;
                                  });
                                },
                                hint: Text(
                                    "Please select the category of your item"),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Row(children: [
                                    Expanded(
                                        child: currLocation
                                            ? Text(
                                                '${userLocation.latitude}',
                                                style: ref.textStyle,
                                              )
                                            : TextField(
                                                controller: itemLatitude,
                                                style: ref.textStyle
                                                    .copyWith(fontSize: 10),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: 'Enter latitude',
                                                  errorText: validateLatitude
                                                      ? 'Fill this field!'
                                                      : null,
                                                ),
                                              )),
                                    Expanded(
                                        child: currLocation
                                            ? Text(
                                                '${userLocation.longitude}',
                                                style: ref.textStyle,
                                              )
                                            : TextField(
                                                controller: itemLongitude,
                                                style: ref.textStyle
                                                    .copyWith(fontSize: 10),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: 'Enter longitude',
                                                  errorText: validateLongitude
                                                      ? 'Fill this field!'
                                                      : null,
                                                ),
                                              )),
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 5, 0, 5),
                                        decoration: BoxDecoration(
                                          color: ref.buttonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              itemLatitude.text = userLocation
                                                  .latitude
                                                  .toString();
                                              itemLongitude.text = userLocation
                                                  .longitude
                                                  .toString();
                                              currLocation = true;
                                              validateLongitude = true;
                                              validateLatitude = true;
                                            });
                                          },
                                          child: Text('Current Location',
                                              style: ref.textStyle),
                                        ))
                                  ]))),
                          SizedBox(height: 10.0),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: TextField(
                                controller: itemPrice,
                                style: ref.textStyle,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Enter the price of your item",
                                  errorText: validatePrice
                                      ? 'Price can\'t be empty!'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          _image != null
                              ? Image.file(_image, height: 200)
                              : Text('Please upload an image for the preview!'),
                          SizedBox(height: 10.0),
                          _image == null
                              ? Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: ref.buttonColor,
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    onPressed: chooseFile,
                                    child: Text('Choose image for your item',
                                        textAlign: TextAlign.center,
                                        style: ref.buttonTextStyle),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10.0),
                          _image != null
                              ? Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: ref.buttonColor,
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: Text('Clear that image',
                                        textAlign: TextAlign.center,
                                        style: ref.buttonTextStyle),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10.0),
                          Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              color: ref.buttonColor,
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () async {
                                  setState(() {
                                    itemTitle.text.isEmpty
                                        ? validateTitle = true
                                        : validateTitle = false;
                                    itemExplanation.text.isEmpty
                                        ? validateExplanation = true
                                        : validateExplanation = false;
                                    itemCategory.text.isEmpty
                                        ? validateCategory = true
                                        : validateCategory = false;
                                    itemPrice.text.isEmpty
                                        ? validatePrice = true
                                        : validatePrice = false;
                                    itemLatitude.text.isEmpty
                                        ? validateLatitude = true
                                        : validateLatitude = false;
                                    itemLongitude.text.isEmpty
                                        ? validateLongitude = true
                                        : validateLongitude = false;
                                  });
                                  if (itemTitle.text.isNotEmpty &&
                                      itemExplanation.text.isNotEmpty &&
                                      itemPrice.text.isNotEmpty &&
                                      itemCategory.text.isNotEmpty &&
                                      itemLatitude.text.isNotEmpty &&
                                      itemLongitude.text.isNotEmpty &&
                                      _image != null) {
                                    double _latitude = currLocation
                                        ? double.parse(
                                            '${userLocation.latitude}')
                                        : double.parse(
                                            itemLatitude.text.toString());
                                    double _longitude = currLocation
                                        ? double.parse(
                                            '${userLocation.longitude}')
                                        : double.parse(
                                            itemLongitude.text.toString());
                                    postItem(
                                        itemTitle.text,
                                        itemExplanation.text,
                                        itemCategory.text,
                                        itemPrice.text,
                                        _latitude,
                                        _longitude);
                                    itemTitle.clear();
                                    itemExplanation.clear();
                                    itemPrice.clear();
                                    itemLatitude.clear();
                                    itemLongitude.clear();
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
