import 'package:flutter/material.dart';

class ChatModule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatModule();
  }
}

class _ChatModule extends State<ChatModule> {
  Widget build(BuildContext context) {return Scaffold(
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
                Image(image: AssetImage('assets/argenova.png')),
                Text('Ahmet Hilmi Berber'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
