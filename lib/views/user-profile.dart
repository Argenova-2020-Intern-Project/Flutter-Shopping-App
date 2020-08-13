import 'package:flutter/material.dart';
import 'package:Intern/views/sign-in.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/main.dart' as ref;

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  final _newName = TextEditingController();
  final _newEmail = TextEditingController();
  final _newPassword = TextEditingController();
  bool _validateNewName = false;
  bool _validateNewEmail = false;
  bool _validateNewPassword = false;
  final formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile", style: ref.appbarTextStyle),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: ref.buttonColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Enter your new name and surname"),
                            content: TextField(
                              controller: _newName,
                              obscureText: false,
                              style: ref.textStyle,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                labelText: "Name-Surname",
                                errorText: _validateNewName
                                    ? 'Name-Surname can\'t be empty!'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Change"),
                                onPressed: () {
                                  setState(() {
                                    _newName.text.isEmpty ? _validateNewName = true : _validateNewName = false;
                                    if(_newName.text.isNotEmpty){
                                      databaseService.changeName(_newName.text);
                                      Navigator.of(context).pop();
                                    }
                                  }); 
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text("Change Name",
                          textAlign: TextAlign.center,
                          style: ref.buttonTextStyle),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Enter your new email"),
                            content: TextField(
                              controller: _newEmail,
                              obscureText: false,
                              style: ref.textStyle,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                labelText: "E-Mail",
                                errorText: _validateNewEmail
                                    ? 'E-mail can\'t be empty!'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Change"),
                                onPressed: () {
                                  setState(() {
                                    _newEmail.text.isEmpty ? _validateNewEmail = true : _validateNewEmail = false;
                                    if(_newEmail.text.isNotEmpty){
                                      databaseService.changeEmail(_newEmail.text);
                                      Navigator.of(context).pop();
                                    }
                                  }); 
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text("Change E-mail",
                          textAlign: TextAlign.center,
                          style: ref.buttonTextStyle),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Enter your new password"),
                            content: TextField(
                              controller: _newPassword,
                              obscureText: true,
                              style: ref.textStyle,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                labelText: "Password",
                                errorText: _validateNewPassword
                                    ? 'Password can\'t be empty!'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Change"),
                                onPressed: () {
                                  setState(() {
                                    _newPassword.text.isEmpty ? _validateNewPassword = true : _validateNewPassword = false;
                                    if(_newPassword.text.isNotEmpty){
                                      databaseService.changePassword(_newPassword.text);
                                      Navigator.of(context).pop();
                                    }
                                  }); 
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text("Change Password",
                          textAlign: TextAlign.center,
                          style: ref.buttonTextStyle),
                    ),
                  ),
                  SizedBox(height: 20.0),Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: ref.buttonColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        authService.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text("Sign Out",
                          textAlign: TextAlign.center,
                          style: ref.buttonTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
