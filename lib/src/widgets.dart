// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/timetable_service.dart';

class Header extends StatelessWidget {
  const Header(this.heading, {super.key});
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black)),
        onPressed: onPressed,
        child: child,
      );
}

class MyBox extends StatefulWidget {
  MyBox({super.key, required this.title, required this.content});
  final String title;
  String content;

  @override
  State<MyBox> createState() => _MyBoxState();
}

class _MyBoxState extends State<MyBox> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(), // this is to create a border
          borderRadius:
              BorderRadius.circular(10), // this is to make corners circular
          // color: Colors.white[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(widget.content),
              Align(
                // this is to Align the button to the bottom right
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    widget.content = await showDialog(
                      // this is to show the dialog popup
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // backgroundColor: Colors.transparent,
                          content: Container(
                            // decoration: BoxDecoration(
                            //   border: Border.all(),
                            //   borderRadius: BorderRadius.circular(10),
                            //   // color: Colors.blue[200],
                            // ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: widget.title,
                                  ),
                                  maxLines: 5,
                                  controller: myController,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          //save here
                                          Navigator.of(context)
                                              .pop(myController.text);
                                        },
                                        icon: Icon(Icons.check_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          //cancel here
                                          Navigator.of(context).pop('');
                                        },
                                        icon: Icon(Icons.close_rounded),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    print(widget.content);
                    setState(() {
                      TimetableService.uploadBottomInfo(
                        widget.content,
                        index: 2,
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
