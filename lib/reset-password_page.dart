import 'package:flutter/material.dart';
import 'package:Intern/auth.dart';
import 'package:Intern/main.dart' as ref;

showAlertDialog(BuildContext context) {
  AuthResultStatus _passResetStat;
  bool _validateResetEmail = false;
  final _resetEmail = TextEditingController();

  Future<AuthResultStatus> resetPassword({email}) async {
    try {
      await ref.auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _passResetStat = AuthExceptionHandler.handleException(e);
    }
    return _passResetStat;
  }

  _resetPassword() async {
    final _status = await resetPassword(email: _resetEmail.text);
    if (_status == AuthResultStatus.invalidEmail ||
        _status == AuthResultStatus.userNotFound) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
      ref.showErrorAlertDialog(context, errorMsg);
    } else {
      //TODO
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
                _resetPassword();
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
