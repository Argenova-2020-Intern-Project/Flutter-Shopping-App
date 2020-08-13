import 'package:flutter/material.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/helper/auth-errors.dart';
import 'package:Intern/views/email-sent.dart';
import 'package:Intern/main.dart' as ref;

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  SignUpPage({this.toggleView});
  @override
  State<StatefulWidget> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  AuthService authService = new AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _termsCond = false;
  bool isLoading = false;

  signUp() async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      final _status =
          await authService.signUp(name:_name.text, email: _email.text, password: _password.text);
      if (_status == AuthResultStatus.successful) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailSendRedirecting(_email.text)),
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
        title: Text("Sing-Up", style: ref.appbarTextStyle),
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
                      SizedBox(height: 25.0),
                      TextField(
                        controller: _name,
                        obscureText: false,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            labelText: "Name-Surname",
                            errorText: _validateName ? 'Name-Surname can\'t be empty!' : null,
                            border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 25.0),
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
                      SizedBox(height: 25.0),
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
                      SizedBox(height: 25.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text("I agree to the terms and conditions",
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.0)),
                            value: _termsCond,
                            subtitle: !_termsCond
                                ? Text('(Required)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.0))
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _termsCond = value;
                              });
                            },
                          )
                        ],
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: ref.buttonColor,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async {
                            setState(() {
                              _email.text.isEmpty
                                  ? _validateEmail = true
                                  : _validateEmail = false;
                              _password.text.isEmpty
                                  ? _validatePassword = true
                                  : _validatePassword = false;
                              _name.text.isEmpty ? _validateName = true : _validateName = false;

                              if (_password.text.isNotEmpty &&
                                  _email.text.isNotEmpty &&
                                  _name.text.isNotEmpty &&
                                  _termsCond) {
                                signUp();
                              }
                            });
                          },
                          child: Text("Sign-Up",
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
