import 'package:flutter/material.dart';
import 'package:Intern/services/auth-errors.dart';
import 'package:Intern/services/auth-helper.dart';
import 'package:Intern/main.dart' as ref;

showAlertDialog(BuildContext context) {
  AuthService authService = new AuthService();
  bool _validateResetEmail = false;
  final _resetEmail = TextEditingController();

  resetPassword() async {
    final _status = await authService.resetPassword(email: _resetEmail.text);
    if (_status == AuthResultStatus.invalidEmail ||
        _status == AuthResultStatus.userNotFound) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
      ref.showErrorAlertDialog(context, errorMsg);
    } else {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          content: Text('The link that you can reset your password sent to ' 
          + _resetEmail.text + '. Please check your E-Mail.', style: ref.style,),
          actions: <Widget>[
            new FlatButton(
              child: Text('Sign-In', style: ref.style),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              }
            )
          ],
        ),
      );
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reset Password'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: _resetEmail,
                obscureText: false,
                style: ref.style,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  labelText: "E-Mail",
                  errorText: _validateResetEmail
                      ? 'E-Mail can\'t be empty!'
                      : null,
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
                resetPassword();
              },
              child: Text("Send link to this E-Mail",
                  textAlign: TextAlign.center,
                  style: ref.style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    },
  );
}