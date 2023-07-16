import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NEW
import '../model/app_state_model.dart'; // NEW

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({super.key});

  @override
  State<CafeteriaPage> createState() => _nameState();
}

class _nameState extends State<CafeteriaPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OIC Cafeteria'),
          backgroundColor: Colors.black,
        ),
        body: ChangeNotifierProvider<AppStateModel>(
          // NEW
          create: (_) => AppStateModel()..loadProducts(), // NEW
          child: const Placeholder(), // NEW
        ),
      ),
    );
  }
}
