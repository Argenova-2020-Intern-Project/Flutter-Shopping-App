import 'package:Intern/views/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Intern/services/location-service.dart';
import 'package:Intern/models/Location.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextStyle textStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
final TextStyle appbarTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 25.0);
final TextStyle buttonTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold);
final buttonColor = Color(0xff01A0C7);
final FirebaseAuth auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child:  MaterialApp(
        title: 'Argenova Flutter Intern Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SignInPage(),
      ));
  }
}

showErrorAlertDialog(BuildContext context, String errorMsg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'An Error Occured',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(errorMsg),
        );
      });
}