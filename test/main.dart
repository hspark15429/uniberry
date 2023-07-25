import 'package:flutter/material.dart';

import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
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
