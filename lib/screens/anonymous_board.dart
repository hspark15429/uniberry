import 'package:firebase_auth/firebase_auth.dart'; // new

import 'package:flutter/material.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:gtk_flutter/guest_book.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import '../src/authentication.dart'; // new

class AnonymousBoard extends StatelessWidget {
  const AnonymousBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anonymous Board'),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (appState.loggedIn)
                            GuestBook(
                              addMessage: (message) =>
                                  appState.addMessageToGuestBook(message),
                              messages: appState.guestBookMessages,
                            ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
