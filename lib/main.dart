import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argenova Flutter Intern Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  final _mail = TextEditingController();
  final _password = TextEditingController();
  bool _validateMail = false;
  bool _validatePassword = false;
  Widget build(BuildContext context) {
    final mailField = TextField(
      controller: _mail,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "E-mail",
        errorText: _validateMail ? 'E-Mail can\'t be empty!' : null,
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
    final signInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            if (_mail.text.isEmpty) {
              _validateMail = true;
            } else {
              _validateMail = false;
            }
            if (_password.text.isEmpty) {
              _validatePassword = true;
            } else {
              _validatePassword = false;
            }
            if (_password.text.isNotEmpty && _mail.text.isNotEmpty) {
              _validateMail = false;
              _validatePassword = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainMenuPage()),
              );
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
      color: Color(0xffBD4752),
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
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 65.0,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'WELCOME TO THE SHOPPING WORLD!',
                      ),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(height: 25.0),
                mailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                signInButton,
                SizedBox(height: 25.0),
                new Text("Don't have an account?"),
                SizedBox(height: 5.0),
                signUpButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  bool _termsCond = false;
  final _name = TextEditingController();
  final _mail = TextEditingController();
  final _password = TextEditingController();
  bool _validateName = false;
  bool _validateMail = false;
  bool _validatePassword = false;
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
    final mailField = TextField(
      controller: _mail,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "E-mail",
        errorText: _validateMail ? 'E-Mail can\'t be empty!' : null,
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
          subtitle: !_termsCond ? Text('(Required)',textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.0)) : null,
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
        onPressed: () {
          setState(() {
            if (_mail.text.isEmpty) {
              _validateMail = true;
            } else {
              _validateMail = false;
            }
            if (_password.text.isEmpty) {
              _validatePassword = true;
            } else {
              _validatePassword = false;
            }
            if (_name.text.isEmpty) {
              _validateName = true;
            } else {
              _validateName = false;
            }
            if (_password.text.isNotEmpty &&
                _mail.text.isNotEmpty &&
                _name.text.isNotEmpty && _termsCond) {
              _validateMail = false;
              _validatePassword = false;
              _validateName = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
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
      appBar: AppBar(
        title: Text("Sign-Up"),
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
                mailField,
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

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
