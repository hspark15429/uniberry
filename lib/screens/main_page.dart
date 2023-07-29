import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 1,
            // ),
            ElevatedButton(
              onPressed: () => openUrl('https://en.ritsumei.ac.jp/'),
              child: Text('School Website'),
            ),
          ],
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
