import 'package:flutter/material.dart';

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
      ),
    );
  }
}
