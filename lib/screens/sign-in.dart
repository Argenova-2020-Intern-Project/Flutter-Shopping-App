import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Intern/screens/sign-up.dart';
import 'package:Intern/services/auth-errors.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/widgets/bottom-nav-bar.dart';
import 'package:Intern/screens/reset-password.dart';
import 'package:Intern/services/shared.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/main.dart' as ref;

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});
  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  AuthService authService = new AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      final _status =
          await authService.signIn(email: _email.text, pass: _password.text);
      if (_status == AuthResultStatus.successful) {
        QuerySnapshot userInfoSnapshot =
            await DatabaseMethods().getUserInfo(_email.text);

        HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.documents[0].data["userName"]);
        HelperFunctions.saveUserEmailSharedPreference(
            userInfoSnapshot.documents[0].data["userEmail"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
        ref.showErrorAlertDialog(context, errorMsg);
      }
    }
  }

  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _email,
      obscureText: false,
      style: ref.textStyle,
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
      style: ref.textStyle,
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
      color: ref.buttonColor,
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
              signIn();
            }
          });
        },
        child: Text("Sign-In",
            textAlign: TextAlign.center,
            style: ref.buttonTextStyle
            ),
      ),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: ref.buttonColor,
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
            style: ref.buttonTextStyle
            ),
      ),
    );

    final resetPasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: ref.buttonColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordPage()),
          );
        },
        child: Text("Reset password",
            textAlign: TextAlign.center,
            style: ref.buttonTextStyle
            ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign In", style: ref.appbarTextStyle),
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
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
