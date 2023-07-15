import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';

Future<String?> dialogBuilder(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop('');
                      },
                      icon: Icon(Icons.cancel)),
                  Header('Dialog'),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('Enable');
                      },
                      child: Text('Save')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('Disable');
                      },
                      child: Text('Delete')),
                ],
              ),
              Row(
                children: [
                  Paragraph('This is a dialog.'),
                ],
              ),
            ],
          ),
        ),

        // AlertDialog(
        //   title: const Text('Basic dialog title'),
        //   content: const Text(
        //     'A dialog is a type of modal window that\n'
        //     'appears in front of app content to\n'
        //     'provide critical information, or prompt\n'
        //     'for a decision to be made.',
        //   ),
        //   actions: <Widget>[
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Disable'),
        //       onPressed: () {
        //         Navigator.of(context).pop('Disable');
        //       },
        //     ),
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Enable'),
        //       onPressed: () {
        //         Navigator.of(context).pop('Enable');
        //       },
        //     ),
        //   ],
        // ),
      );
    },
  );
}
