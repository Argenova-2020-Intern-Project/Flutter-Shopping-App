import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Intern/models/Message.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/shared/MessageTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String targetUserId;
  final String chatId;

  ChatScreen({this.currentUserId, this.targetUserId, this.chatId});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  DatabaseService databaseService = DatabaseService();
  TextEditingController sendMsgCtrl = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode textFieldFocus;

  void onSubmitMsg() async {
    if (sendMsgCtrl.text.trim().isEmpty) {
    } else {
      String msg = sendMsgCtrl.text;
      sendMsgCtrl.text = "";
      insertMessage(msg);
    }
  }

  void insertMessage(String content) async {
    databaseService.insertMessage(
        Message(
            time: Timestamp.now(),
            content: content,
            senderId: widget.currentUserId),
        widget.chatId);
  }

  @override
  void dispose() {
    sendMsgCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<Message>>(context);
    Timer(Duration(milliseconds: 500), () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                controller: scrollController,
                reverse: false,
                itemCount: messages == null ? 0 : messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    isSelf: messages[index].senderId == widget.currentUserId
                        ? true
                        : false,
                    msg: messages[index].content,
                    timestamp: messages[index].time,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: textFieldFocus,
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                      onSubmitMsg();
                    },
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter your message here',
                    ),
                    controller: sendMsgCtrl,
                  ),
                ),
                IconButton(
                  onPressed: () => onSubmitMsg(),
                  icon: Icon(Icons.send, color: Colors.redAccent),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
