import 'package:flutter/material.dart';
import 'package:Intern/screens/sign-in.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/main.dart' as ref;

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  AuthService authService = new AuthService();
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: ListView(
          padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Menu', textAlign: TextAlign.center),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                ),
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: ref.buttonColor,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    authService.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text("Sign Out",
                      textAlign: TextAlign.center,
                      style: ref.buttonTextStyle
                      ),
                ),
              ),
            ],
          ),
        )
      ),
      
    );
  }
}
