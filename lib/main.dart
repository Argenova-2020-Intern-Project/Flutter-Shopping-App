import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _success;
  String _userEmail;
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _email,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "E-mail",
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

    void _signInWithEmailAndPassword() async {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    }

    final signInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            if (_email.text.isEmpty) {
              _validateEmail = true;
            } else {
              _validateEmail = false;
            }
            if (_password.text.isEmpty) {
              _validatePassword = true;
            } else {
              _validatePassword = false;
            }
            if (_password.text.isNotEmpty && _email.text.isNotEmpty) {
              _signInWithEmailAndPassword();
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
      resizeToAvoidBottomInset: false,
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
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                signInButton,
                SizedBox(height: 25.0),
                new Text("Don't have an account?"),
                SizedBox(height: 5.0),
                signUpButton,
                Text(_success == null
                    ? ''
                    : (_success
                        ? 'Successfully signed in ' + _userEmail
                        : 'Sign-In failed')),
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
        labelText: "E-mail",
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
                  textAlign: TextAlign.center,
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
            if (_email.text.isEmpty) {
              _validateEmail = true;
            } else {
              _validateEmail = false;
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
                _email.text.isNotEmpty &&
                _name.text.isNotEmpty &&
                _termsCond) {
              signUpProcess(_email.text, _password.text);
            }
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmailSendRedirecting(_email.text)));
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

class EmailSendRedirecting extends StatelessWidget {
  final String _mail;
  EmailSendRedirecting(this._mail);

  @override
  Widget build(BuildContext context) {
    final signInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
        child: Text("Sign-In",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Redirecting.."),
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
                Text('The verification mail has been sen to ' +
                    _mail +
                    '. Please check your E-Mail and verify your account'),
                SizedBox(height: 50.0),
                signInButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
