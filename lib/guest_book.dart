import 'package:flutter/material.dart';

import 'src/widgets.dart';
import 'model/guest_book_message.dart';

class GuestBook extends StatefulWidget {
  // Modify the following line:
  const GuestBook({
    super.key,
    required this.messages,
  });

  final List<GuestBookMessage> messages; // new

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  @override
  // Modify from here...
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ...to here.

        // Modify from here...
        const SizedBox(height: 8),
        for (var message in widget.messages) ...[
          Paragraph('Anon: ${message.message}'),
          // Paragraph('${message.message}')
        ],
        const SizedBox(height: 8),
      ],
      // ...to here.
    );
  }
}
