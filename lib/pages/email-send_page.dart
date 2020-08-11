import 'package:flutter/material.dart';
import 'package:Intern/pages/sign-in_page.dart';
import 'package:Intern/main.dart' as ref;
class EmailSendRedirecting extends StatelessWidget {
  final String _mail;
  EmailSendRedirecting(this._mail);

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
            style: ref.style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Redirecting..", style: ref.style.copyWith(fontSize: 23)),
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
                Text(
                    'The verification mail has been sent to ' +
                        _mail +
                        '. Please check your E-Mail and verify your account',
                    style: ref.style),
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
