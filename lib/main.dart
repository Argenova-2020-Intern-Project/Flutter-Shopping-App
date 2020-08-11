import 'package:Intern/screens/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:Intern/widgets/bottom-nav-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

final TextStyle textStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
final TextStyle appbarTextStyle = textStyle.copyWith(fontSize: 25);
final TextStyle buttonTextStyle =
    textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
final buttonColor = Color(0xff01A0C7);
final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argenova Flutter Intern Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),
    );
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
