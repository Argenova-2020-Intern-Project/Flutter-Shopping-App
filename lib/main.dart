import 'package:flutter/material.dart';
import 'package:Intern/bottom-nav-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() => runApp(MyApp());

final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
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
      home: BottomNavBar(),
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
    }
  );
}
