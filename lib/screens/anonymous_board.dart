import 'package:firebase_auth/firebase_auth.dart'; // new

import 'package:flutter/material.dart';
import 'package:gtk_flutter/model/app_state.dart';
import 'package:gtk_flutter/guest_book.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import '../src/authentication.dart'; // new

class AnonymousBoard extends StatefulWidget {
  const AnonymousBoard({super.key});

  @override
  State<AnonymousBoard> createState() => _AnonymousBoardState();
}

class _AnonymousBoardState extends State<AnonymousBoard> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anonymous Board'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Leave a message',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your message to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    StyledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String message = _controller.text;
                          await context
                              .read<ApplicationState>()
                              .addMessageToGuestBook(message);
                          _controller.clear();
                        }
                      },
                      child: Row(
                        children: const [
                          Icon(
                            color: Colors.black,
                            Icons.send,
                          ),
                          SizedBox(width: 4),
                          Text(
                            style: TextStyle(color: Colors.black),
                            'SEND',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Consumer<ApplicationState>(
                        builder: (context, appState, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (appState.loggedIn)
                                  GuestBook(
                                    messages: appState.guestBookMessages,
                                  ),
                              ],
                            )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
