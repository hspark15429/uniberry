import 'package:flutter/material.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:gtk_flutter/screens/anonymous_board.dart';
import 'package:gtk_flutter/screens/cafeteria_page.dart';
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
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.explore),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.commute),
            label: '시간표',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: '익명게시판',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: '급식표/강의평가/중고거래',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.yellow,
          alignment: Alignment.center,
          child: const Text('Page 1'),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => TimetablePage(),
          ),
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
}
