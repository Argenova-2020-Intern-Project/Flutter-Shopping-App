import 'package:flutter/material.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/helper/auth-errors.dart';
import 'package:password/password.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:Intern/main.dart' as ref;
import 'package:path/path.dart' as Path;

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
  File _image;
  final algorithm = PBKDF2();

  Future<void> _signInAnonymously() async {
    try {
      await ref.auth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    _signInAnonymously();
    super.initState();
  }

  signUp() async {
    if (formKey.currentState.validate()) {
      isLoading = true;

      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile-photos/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      storageReference.getDownloadURL().then((fileURL) async{

        final hashedPassword = Password.hash(_password.text, algorithm);
        final _status = await authService.signUp(
            name: _name.text,
            email: _email.text,
            password: hashedPassword,
            img_url: fileURL);
        if (_status == AuthResultStatus.successful) {
          Toast.show(
              'The verification mail has been sent to ' +
                  _email.text +
                  '. Please check your E-Mail to verify your account',
              context,
              duration: 6,
              backgroundColor: ThemeData.dark().dialogBackgroundColor);
          Navigator.of(context).pop();
        } else {
          isLoading = false;
          final errorMsg = AuthExceptionHandler.generateExceptionMessage(_status);
          ref.showErrorAlertDialog(context, errorMsg);
        }
      });
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
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
                padding: EdgeInsets.all(36.0),
                child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                            onPressed: chooseFile,
                            child: _image == null
                                ? Icon(Icons.photo_camera, size: 50)
                                : CircleAvatar(
                          backgroundImage:
                              AssetImage(_image.path),
                              backgroundColor: Colors.blue,
                          radius: 80.0,
                          ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                      SizedBox(height: 25.0),
                      TextField(
                        controller: _name,
                        obscureText: false,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            labelText: "Name-Surname",
                            errorText: _validateName
                                ? 'Name-Surname can\'t be empty!'
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 25.0),
                      TextField(
                        controller: _email,
                        obscureText: false,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "E-Mail",
                          errorText:
                              _validateEmail ? 'E-Mail can\'t be empty!' : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        style: ref.textStyle,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: "Password",
                          errorText: _validatePassword
                              ? 'Password can\'t be empty!'
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text("I agree to the terms and conditions",
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 11.0)),
                            value: _termsCond,
                            subtitle: !_termsCond
                                ? Text('(Required)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 11.0))
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
                              _name.text.isEmpty
                                  ? _validateName = true
                                  : _validateName = false;

                              if (_password.text.isNotEmpty &&
                                  _email.text.isNotEmpty &&
                                  _name.text.isNotEmpty &&
                                  _termsCond &&
                                  _image != null) {
                                signUp();
                              }
                            });
                          },
                          child: Text("Sign-Up",
                              textAlign: TextAlign.center,
                              style: ref.buttonTextStyle),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
          ),
    );
  }
}
