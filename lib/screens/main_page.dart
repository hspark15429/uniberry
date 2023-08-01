import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/screens/home_page.dart';
import 'package:gtk_flutter/services/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Main Page',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('A')),
                    title: Text('Manaba'),
                    subtitle: Text('Supporting text'),
                    onTap: () => openUrl('https://ct.ritsumei.ac.jp/ct/'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('B')),
                    title: Text('학사력'),
                    subtitle: Text('Supporting text'),
                    onTap: () => openUrl(
                        'https://www.ritsumei.ac.jp/profile/info/calendar/'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('C')),
                    title: Text('학부수업스케줄'),
                    subtitle: Text('Supporting text'),
                    onTap: () => openUrl(
                        'https://www.ritsumei.ac.jp/file.jsp?id=562469'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('D')),
                    title: Text('대학도서관'),
                    subtitle: Text('Supporting text'),
                    onTap: () => openUrl(
                        'https://runners.ritsumei.ac.jp/opac/opac_search/?lang=0'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('E')),
                    title: Text('학교홈페이지'),
                    subtitle: Text('Supporting text'),
                    onTap: () => openUrl('https://en.ritsumei.ac.jp/'),
                  ),
                ),
                // go to /
                Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: Text('Back'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> openUrl(String url) async {
  final _url = Uri.parse(url);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    // <--
    throw Exception('Could not launch $_url');
  }
}

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListTile Sample')),
      body: ListView(
        children: const <Widget>[
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Headline'),
            subtitle: Text('Supporting text'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(child: Text('B')),
            title: Text('Headline'),
            subtitle: Text(
                'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
