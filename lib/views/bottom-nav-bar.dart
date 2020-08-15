import 'package:flutter/material.dart';
import 'package:Intern/views/sell-stuff_page.dart';
import 'package:Intern/views/categories.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/views/user-profile.dart';
import 'package:Intern/views/home/home.dart';
import 'package:Intern/views/messenger/messenger.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavBar();
  }
}

class _BottomNavBar extends State<BottomNavBar> {
  AuthService authService = new AuthService();
  int _currentIndex = 0;

  Widget tabs(int _tabIndex) {
    switch (_currentIndex) {
      case 0:
        return HomePage();
        break;
      case 1:
        return Messenger();
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
      body: SafeArea(
        child: tabs(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20, color: Colors.cyan),
            title: Text("Home", style: TextStyle(fontSize: 15,
              color: _currentIndex == 0 ? Color(0xffF2A7B3) : Color(0xFF34323D)),
            ),
            activeIcon: Icon(Icons.home, size: 20, color: Color(0xffF2A7B3)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 20, color: Colors.cyan),
            title: Text("Messages", style: TextStyle(fontSize: 15,
              color: _currentIndex == 1 ? Color(0xffF2A7B3) : Color(0xFF34323D)),
            ),
            activeIcon: Icon(Icons.message, size: 20, color: Color(0xffF2A7B3)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 20, color: Colors.cyan),
            title: Text("Sell Stuff", style: TextStyle(fontSize: 15,
              color: _currentIndex == 2 ? Color(0xffF2A7B3) : Color(0xFF34323D)),
            ),
            activeIcon: Icon(Icons.add_circle, size: 20, color: Color(0xffF2A7B3)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, size: 20, color: Colors.cyan),
            title: Text("Categories", style: TextStyle(fontSize: 15,
              color: _currentIndex == 3 ? Color(0xffF2A7B3) : Color(0xFF34323D)),
            ),
            activeIcon: Icon(Icons.category, size: 20, color: Color(0xffF2A7B3)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 20, color: Colors.cyan),
            title: Text("Profile", style: TextStyle(fontSize: 15,
              color: _currentIndex == 4 ? Color(0xffF2A7B3) : Color(0xFF34323D)),
            ),
            activeIcon: Icon(Icons.account_circle, size: 20, color: Color(0xffF2A7B3)),
          ),
        ],
      ),
    );
  }
}