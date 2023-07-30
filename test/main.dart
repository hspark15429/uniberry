import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
