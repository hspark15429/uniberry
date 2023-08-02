import 'package:flutter/material.dart';
import 'package:gtk_flutter/model/app_state.dart';

import 'package:gtk_flutter/screens/anonymous_board.dart';
import 'package:gtk_flutter/screens/cafeteria_page.dart';
import 'package:gtk_flutter/screens/main_page.dart';
import 'package:gtk_flutter/screens/timetable_page.dart';
import 'package:provider/provider.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is authenticated when the widget is initialized
    if (!isUserAuthenticated(context)) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    }
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Main',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: '時間割',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum),
            label: '匿名チャット',
          ),
          NavigationDestination(
            icon: Icon(Icons.ramen_dining),
            label: '学食メニュー',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          // color: Colors.yellow,
          alignment: Alignment.center,
          child: const MainPage(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const TimetablePage(),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const AnonymousBoard(),
        ),
        Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const CafeteriaPage(),
        ),
      ][currentPageIndex],
    );
  }

  bool isUserAuthenticated(BuildContext context) {
    final appState = context.watch<ApplicationState>();
    return appState.loggedIn;
  }
}
