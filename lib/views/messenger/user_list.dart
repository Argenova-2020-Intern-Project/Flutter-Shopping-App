import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/User.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:flutter/material.dart';

import 'messenger_detail.dart';

class UserList extends StatefulWidget {
  final List<User> userList;

  UserList({@required this.userList});

  @override
  State createState() => UserListState();
}

class UserListState extends State<UserList> {
  ScrollController scrollController = ScrollController();
  DatabaseService databaseService = DatabaseService();
  final int maxUserFromScreen = 10;

  void navigateToDetail(User targetUser) async {
    FirebaseUser currentUser = await AuthService().getCurrentUser();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MessengerDetail(targetUser: targetUser, currentUser: currentUser),
      )
    );
  }

  void getMoreData() async {
    var newList =
        await databaseService.users(limit: maxUserFromScreen, isFirst: false);
    if (newList.length > 0) {
      widget.userList.addAll(newList);
    }
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.userList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () => navigateToDetail(widget.userList[index]),
            dense: true,
            title: Text(
                "${widget.userList[index].name}"
            ),
            subtitle: Text(widget.userList[index].email),
          )
        );
      }
    );
  }
}
