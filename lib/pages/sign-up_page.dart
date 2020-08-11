import 'package:flutter/material.dart';
import 'package:Intern/services/auth-helper.dart';
import 'package:Intern/services/auth-errors.dart';
import 'package:Intern/pages/email-send_page.dart';
import 'package:Intern/main.dart' as ref;

class SignUpPage extends StatefulWidget {
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
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _termsCond = false;

  signUp() async {
    final _status = await authService.signUp(email: _email.text, pass: _password.text);
    if (_status == AuthResultStatus.successful) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmailSendRedirecting(_email.text)),
      );
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
      ref.showErrorAlertDialog(context, errorMsg);
    }
  }

  Widget build(BuildContext context) {
    final nameSurnameField = TextField(
      controller: _name,
      obscureText: false,
      style: ref.style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Name-Surname",
          errorText: _validateName ? 'Name-Surname can\'t be empty!' : null,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

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

    final terms = Column(
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
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffBD4752),
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
            style: ref.style
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sing-Up", style: ref.style.copyWith(fontSize: 23)),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25.0),
                nameSurnameField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                terms,
                signUpButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
