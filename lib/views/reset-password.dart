import 'package:flutter/material.dart';
import 'package:Intern/helper/auth-errors.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/main.dart' as ref;

class ResetPasswordPage extends StatefulWidget {
  final Function toggleView;
  ResetPasswordPage({this.toggleView});
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordPage();
  }
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  AuthService authService = new AuthService();
  final _resetEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _validateResetEmail = false;
  bool isLoading = false;

  resetPassword() async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      final _status = await authService.resetPassword(email: _resetEmail.text);
      if (_status == AuthResultStatus.invalidEmail ||
          _status == AuthResultStatus.userNotFound) {
        setState(() {
          isLoading = false;
        });
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
        ref.showErrorAlertDialog(context, errorMsg);
      } else {
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: Text(
              'The link that you can reset your password sent to ' +
                  _resetEmail.text +
                  '. Please check your E-Mail.',
              style: ref.textStyle,
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text('Sign-In', style: ref.textStyle),
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  })
            ],
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _resetEmail,
      style: ref.textStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "E-Mail",
        errorText: _validateResetEmail ? 'E-Mail can\'t be empty!' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
          setState(() {
            resetPassword();
          });
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
        title: Text("Reset Password", style: ref.appbarTextStyle),
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
                      emailField,
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
