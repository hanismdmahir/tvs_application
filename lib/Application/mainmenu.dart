import 'package:flutter/material.dart';
import 'Account/account.dart';
import 'Chat/chatdetails.dart';
import 'Dashboard/dashboardMenu.dart';
import 'Info/infoPN.dart';
import 'Info/infomain.dart';
import '../Model/User.dart';
import 'Reminder/remindermain.dart';
import 'record.dart';

class MainMenuScreen extends StatefulWidget {
  MainMenuScreen(this.user);

  final UserModel user;

  @override
  _MainMenuSreenState createState() => _MainMenuSreenState();
}

class _MainMenuSreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  List<Widget> _patient = [];

  List<Widget> _pN = [];

  @override
  void initState() {
    _patient = [
      RecordMainScreen(),
      ReminderMainScreen(),
      ChatDetailsScreen(u: widget.user),
      ListInfoScreen(),
      AccountScreen()
    ];

    _pN = [
      DashboardMenuScreen(u: widget.user),
      ListInfoPNScreen(),
      AccountScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.user.patient ? _patient[_currentIndex] : _pN[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff0245A3),
        unselectedItemColor: Color(0xff06224A),
        items: widget.user.patient
            ? [
                BottomNavigationBarItem(
                    label: 'Records', icon: new Icon(Icons.library_books)),
                BottomNavigationBarItem(
                    label: 'Reminder', icon: new Icon(Icons.alarm)),
                BottomNavigationBarItem(
                    label: 'Chat',
                    icon: new Icon(Icons.chat_bubble_outline_rounded)),
                BottomNavigationBarItem(
                    label: 'Info', icon: new Icon(Icons.info_outline_rounded)),
                BottomNavigationBarItem(
                    label: 'Account', icon: Icon(Icons.person))
              ]
            : [
                BottomNavigationBarItem(
                    label: 'Patients', icon: new Icon(Icons.group_outlined)),
                BottomNavigationBarItem(
                    label: 'Info', icon: new Icon(Icons.info_outline_rounded)),
                BottomNavigationBarItem(
                    label: 'Account', icon: Icon(Icons.person))
              ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
