import 'package:flutter/material.dart';
import 'package:Intern/helper/auth-errors.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:toast/toast.dart';
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
        Toast.show('The link that you can reset your password sent to ' +
                  _resetEmail.text +
                  '. Please check your E-Mail.', context, duration: 6,
        backgroundColor: ThemeData.dark().dialogBackgroundColor);
        Navigator.of(context).pop();
      }
    }
  }

  Widget build(BuildContext context) {
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
                      TextField(
                        controller: _resetEmail,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "E-Mail",
                          errorText: _validateResetEmail ? 'E-Mail can\'t be empty!' : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Material(
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
                              textAlign: TextAlign.center, style: ref.buttonTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
