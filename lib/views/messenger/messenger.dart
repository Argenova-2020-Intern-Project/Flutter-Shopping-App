import 'package:Intern/models/User.dart';
import 'package:Intern/views/messenger/user_list.dart';
import 'package:Intern/services/database.dart';
import 'package:flutter/material.dart';
import 'package:Intern/main.dart' as ref;

class Messenger extends StatefulWidget {
  @override
  State createState() => MessengerState();
}

class MessengerState extends State<Messenger> {
  List<User> userList = List();
  final TextEditingController searchCtrl = TextEditingController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final DatabaseService databaseService = DatabaseService();
  Future future;

  void onSubmitSearch(String key) {
    setState(() {
      future = databaseService.searchUser(key);
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    future = databaseService.users(limit: 10, isFirst: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextFormField(
          style: ref.appbarTextStyle,
          controller: searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search Chats',
            prefixIcon: Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                color: Colors.white,
                onPressed: () => searchCtrl.clear()),
          ),
          onFieldSubmitted: onSubmitSearch,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          userList = snapshot.data;
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : UserList(userList: userList);
        },
      ),
    );
  }
}
