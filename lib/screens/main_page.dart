import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/screens/home_page.dart';
import 'package:gtk_flutter/services/firebase_service.dart';
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
            Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 8),
              child: ElevatedButton(
                onPressed: () => openUrl('https://en.ritsumei.ac.jp/'),
                child: Text('School Website'),
              ),
            ),
            // go to /
            Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 8),
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text('Back'),
              ),
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
