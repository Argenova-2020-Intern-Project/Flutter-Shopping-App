import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/auth.dart';
import 'package:Intern/sign-up_page.dart';
import 'package:Intern/reset-password_page.dart';
import 'package:Intern/bottom-nav-bar.dart';
import 'package:Intern/main.dart' as ref;

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  AuthResultStatus _singInStat;

  Future<AuthResultStatus> signIn({email, pass}) async {
    try {
      AuthResult result = await ref.auth
          .signInWithEmailAndPassword(email: email, password: pass);
      if (result.user != null) {
        _singInStat = AuthResultStatus.successful;
      } else {
        _singInStat = AuthResultStatus.undefined;
      }
    } catch (e) {
      _singInStat = AuthExceptionHandler.handleException(e);
    }
    return _singInStat;
  }

  _signIn() async {
    final _status = await signIn(email: _email.text, pass: _password.text);
    if (_status == AuthResultStatus.successful) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
      ref.showErrorAlertDialog(context, errorMsg);
    }
  }

  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _email,
      obscureText: false,
      style: ref.style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "E-Mail",
        errorText: _validateEmail ? 'E-Mail can\'t be empty!' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextField(
      controller: _password,
      obscureText: true,
      style: ref.style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Password",
        errorText: _validatePassword ? 'Password can\'t be empty!' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            _email.text.isEmpty
                ? _validateEmail = true
                : _validateEmail = false;
            _password.text.isEmpty
                ? _validatePassword = true
                : _validatePassword = false;
            if (_password.text.isNotEmpty && _email.text.isNotEmpty) {
              _signIn();
            }
          });
        },
        child: Text("Sign-In",
            textAlign: TextAlign.center,
            style: ref.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
        },
        child: Text("Sign-Up",
            textAlign: TextAlign.center,
            style: ref.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final resetPasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showAlertDialog(context);
        },
        child: Text("Reset password",
            textAlign: TextAlign.center,
            style: ref.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/argenova.png')),
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(height: 20.0),
                signInButton,
                SizedBox(height: 20.0),
                signUpButton,
                SizedBox(height: 20.0),
                resetPasswordButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
