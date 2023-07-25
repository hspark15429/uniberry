import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'src/authentication.dart'; // new
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uniberry'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/schoolLogo.png', height: 140),
          const SizedBox(height: 8),
          // DisplayName(),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          // Show school photos, front page.
          Container(
            width: 100, // specify the width of the box
            height: 500, // specify the height of the box
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2, // adjust this as per your requirement
              children: <Widget>[
                Image.asset('assets/school1.png', fit: BoxFit.cover),
                Image.asset('assets/school2.png', fit: BoxFit.cover),
                Image.asset('assets/school3.png', fit: BoxFit.cover),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayName extends StatelessWidget {
  const DisplayName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        String displayName = '';

        var _canShowDisplayName = appState.loggedIn;

        // if (_canShowDisplayName) {
        //   final displayName = FirebaseAuth.instance.currentUser!.displayName!;
        //   print(_canShowDisplayName);
        // }
        return Center(child: Header(displayName));
      },
    );
  }
}
