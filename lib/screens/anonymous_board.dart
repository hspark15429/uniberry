import 'package:flutter/material.dart';
import 'package:gtk_flutter/guest_book.dart';
import 'package:gtk_flutter/model/app_state.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import 'Chat/dm_list_page.dart';

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
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Text(
            '匿名チャット',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          
          backgroundColor: const Color.fromARGB(255, 32, 30, 30),
         automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // 여기에서 DMListPage로 이동하는 로직을 추가합니다.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DMListPage()),
              );
            },
          ),
        ],
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
                        hintText: "伝言を残す。", // 'Leave a message',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "続行するにはメッセージを入力してください"; // 'Enter your message to continue';
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
                          // color: Colors.black,
                          Icons.send,
                        ),
                        SizedBox(width: 4),
                        Text(
                            // style: TextStyle(color: Colors.black),
                            "送信" // 'SEND',
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
    );
    
  }
}
