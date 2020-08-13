import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/User.dart';
import 'package:Intern/views/messenger/chat_screen.dart';
import 'package:Intern/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessengerDetail extends StatefulWidget {
  static const String route_id = "/messenger_detail";
  final User targetUser;
  final FirebaseUser currentUser;

  MessengerDetail({this.targetUser, this.currentUser});

  @override
  State createState() => MessengerDetailState();
}

class MessengerDetailState extends State<MessengerDetail> {
  DatabaseService databaseService = DatabaseService();
  String getChatId() {
    String id = widget.currentUser.uid;
    String targetId = widget.targetUser.uid;
    return (id.hashCode < targetId.hashCode) ? "$id$targetId" : "$targetId$id";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DatabaseService().deleteMessages(getChatId());
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("${widget.targetUser.name}".toUpperCase()),
          ],
        ),
      ),
      body: StreamProvider.value(
        value: DatabaseService().messages(getChatId()),
        child: ChatScreen(
          currentUserId: widget.currentUser.uid,
          targetUserId: widget.targetUser.uid,
          chatId: getChatId(),
        ),
      ),
    );
  }
}
