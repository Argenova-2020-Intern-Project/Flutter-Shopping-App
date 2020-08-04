import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  final _resetEmail = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _success;
  String _userEmail;

  _onAlertWithStylePressed(context) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 500));

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: "Success",
      desc: "The reset link sent to " + _resetEmail.text 
      + ". Please check your mailbox",
      buttons: [
        DialogButton(
          child: Text(
            "Got it",
            style: style,
          ),
          onPressed: (){
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2); 
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  Widget _resetPassword(BuildContext context) {
    return new AlertDialog(
      title: const Text('Reset Your Password'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _resetEmail,
            obscureText: false,
            style: style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              labelText: "E-Mail",
              errorText: _validateEmail ? 'E-Mail can\'t be empty!' : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(height: 25.0),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Color(0xff01A0C7),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () async {
                await _firebaseAuth.sendPasswordResetEmail(
                    email: _resetEmail.text);
                    _onAlertWithStylePressed(context);
              },
              child: Text("Send Link to this E-Mail",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
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
      color: Color(0xff01A0C7),
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

    final resetPasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _resetPassword(context),
          );
          // Perform some action
        },
        child: Text("Reset password",
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
                /*SizedBox(
                    height: 65.0,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'WELCOME TO THE SHOPPING WORLD!',
                      ),
                      textAlign: TextAlign.center,
                    )),*/
                Image(image: AssetImage('assets/argenova.png')),
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(height: 20.0),
                signInButton,
                SizedBox(height: 20.0),
                signUpButton,
                SizedBox(height: 5.0),
                Text(_success == null
                    ? ''
                    : (_success
                        ? 'Successfully signed as ' + _userEmail
                        : 'Sign-In failed')),
                resetPasswordButton,
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
