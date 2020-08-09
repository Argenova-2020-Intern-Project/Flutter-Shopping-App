import 'package:flutter/material.dart';
import 'package:Intern/home-page.dart';
import 'package:Intern/chat-module.dart';
import 'package:Intern/sell-stuff.dart';
import 'package:Intern/categories.dart';
import 'package:Intern/user-profile.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavBar();
  }
}

class _BottomNavBar extends State<BottomNavBar> {
  int _currentIndex = 0;

  Widget _tabs(int _tabIndex) {
    switch (_currentIndex) {
      case 0:
        return HomePage();
        break;
      case 1:
        return ChatModule();
        break;
      case 2:
        return SellStuff();
        break;
      case 3:
        return Categories();
        break;
      case 4:
        return UserProfile();
        break;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Search"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: SafeArea(
        child: _tabs(_currentIndex),
      ),
      drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
              color: Colors.cyan,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                  fontSize: 15,
                  color: _currentIndex == 0
                      ? Color(0xffF2A7B3)
                      : Color(0xFF34323D)),
            ),
            activeIcon: Icon(
              Icons.home,
              size: 20,
              color: Color(0xffF2A7B3),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 20,
              color: Colors.cyan,
            ),
            title: Text(
              "Messages",
              style: TextStyle(
                  fontSize: 15,
                  color: _currentIndex == 1
                      ? Color(0xffF2A7B3)
                      : Color(0xFF34323D)),
            ),
            activeIcon: Icon(
              Icons.message,
              size: 20,
              color: Color(0xffF2A7B3),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 20,
              color: Colors.cyan,
            ),
            title: Text(
              "Sell Stuff",
              style: TextStyle(
                  fontSize: 15,
                  color: _currentIndex == 2
                      ? Color(0xffF2A7B3)
                      : Color(0xFF34323D)),
            ),
            activeIcon: Icon(
              Icons.add_circle,
              size: 20,
              color: Color(0xffF2A7B3),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              size: 20,
              color: Colors.cyan,
            ),
            title: Text(
              "Categories",
              style: TextStyle(
                  fontSize: 15,
                  color: _currentIndex == 3
                      ? Color(0xffF2A7B3)
                      : Color(0xFF34323D)),
            ),
            activeIcon: Icon(
              Icons.category,
              size: 20,
              color: Color(0xffF2A7B3),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 20,
              color: Colors.cyan,
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                  fontSize: 15,
                  color: _currentIndex == 4
                      ? Color(0xffF2A7B3)
                      : Color(0xFF34323D)),
            ),
            activeIcon: Icon(
              Icons.account_circle,
              size: 20,
              color: Color(0xffF2A7B3),
            ),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final search = [];

  final recentSearch = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.green,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : search.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.arrow_forward),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey)),
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
