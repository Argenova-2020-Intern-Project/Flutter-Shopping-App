import 'package:Intern/views/bottom-nav-bar.dart';
import 'package:flutter/material.dart';
import 'package:Intern/views/sign-up.dart';
import 'package:Intern/helper/auth-errors.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/views/reset-password.dart';
import 'package:password/password.dart';
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
  final algorithm = PBKDF2();

  signIn() async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      final hashedPassword = Password.hash(_password.text, algorithm);
      final _status =
          await authService.signIn(email: _email.text, pass: hashedPassword);
      if (_status == AuthResultStatus.successful) {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  padding: EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/argenova.png')),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _email,
                        obscureText: false,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "E-Mail",
                          errorText: _validateEmail ? 'E-Mail can\'t be empty!' : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "Password",
                          errorText: _validatePassword ? 'Password can\'t be empty!' : null,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
