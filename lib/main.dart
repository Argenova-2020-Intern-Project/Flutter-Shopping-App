import 'package:flutter/material.dart';
import 'package:Intern/sign-in_page.dart';

void main() => runApp(MyApp());

final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

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