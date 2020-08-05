import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/email-send_page.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _termsCond = false;

  @override
  Widget build(BuildContext context) {
    final nameSurnameField = TextField(
      controller: _name,
      obscureText: false,
      style: style,
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

    @override
    void signUpProcess(String email, String password) async {
      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      try {
        await user.sendEmailVerification();
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }
    }

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
              signUpProcess(_email.text, _password.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmailSendRedirecting(_email.text)));
            }
          });
        },
        child: Text("Sign-Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sing-Up", style: style.copyWith(fontSize: 23)),
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
