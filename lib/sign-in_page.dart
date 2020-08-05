import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/sign-up_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  final _email = TextEditingController();
  final _resetEmail = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validateResetEmail = false;
  bool _validatePassword = false;
  bool _successSignIn;
  Future<void> _resetPassword() async {
    Future<void> resetPassword(String email) async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _resetEmail,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    labelText: "E-Mail",
                    errorText:
                        _validateResetEmail ? 'E-Mail can\'t be empty!' : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xff01A0C7),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  setState(() {
                    if (_resetEmail.text.isEmpty) {
                      _validateResetEmail = true;
                    } else {
                      _validateResetEmail = false;
                      resetPassword(_resetEmail.text);
                    }
                  });
                },
                child: Text("Send Link to this E-Mail",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _email,
      obscureText: false,
      style: style,
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
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Password",
        errorText: _validatePassword ? 'Password can\'t be empty!' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    Future<String> _signInWithEmailAndPassword() async {
      FirebaseUser user;
      String errorMessage;
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        user = result.user;
        setState(() {
          if (user != null) {
            _successSignIn = true;
          } else {
            _successSignIn = false;
          }
        });
      } catch (error) {
        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
      }

      if (errorMessage != null) {
        return Future.error(errorMessage);
      }

      return user.uid;
    }

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
              _signInWithEmailAndPassword();
            }
          });
        },
        child: Text("Sign-In",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
          _resetPassword();
        },
        child: Text("Reset password",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
                SizedBox(height: 10.0),
                Text(_successSignIn == null
                    ? ''
                    : (_successSignIn
                        ? 'Successfully signed as ' + _email.text
                        : 'Sign-In failed')),
                SizedBox(height: 10.0),
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