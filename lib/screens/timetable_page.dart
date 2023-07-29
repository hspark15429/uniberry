import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'dialog_builder.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int day = DateTime.now().weekday;
  int time = int.parse(DateFormat('HHmm').format(DateTime.now()));
  int _timetableIndex = 1;

  // late ApplicationState appState;
  late Map<String, String> localTimetable;
  late int cellNow;

  @override
  void initState() {
    super.initState();
    localTimetable = {for (int i = 1; i <= 25; i++) i.toString(): ""};
    setCurrentTimeSlot();
    loadServerTimetable();
  }

  @override
  Widget build(BuildContext context) {
    // save current timetable to firestore
    uploadLocalTimetable();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Timetable$_timetableIndex'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  icon: const Icon(Icons.cleaning_services_outlined),
                  tooltip: 'Clean up',
                  onPressed: () {
                    setState(() {
                      localTimetable = {
                        for (int i = 1; i <= 25; i++) i.toString(): ""
                      };
                    });
                  }),
              IconButton(
                  icon: const Icon(CupertinoIcons.settings),
                  tooltip: 'More options',
                  onPressed: () {
                    // handle the press
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text('Share'),
                              ),
                              ListTile(
                                leading: Icon(Icons.copy),
                                title: Text('Copy Link'),
                              ),
                              ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ],
                          );
                        });
                  }),
              IconButton(
                  icon: const Icon(CupertinoIcons.bars),
                  tooltip: 'Timetable List',
                  onPressed: () {
                    // handle the press
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Timetable List'),
                            content: Text('Select a timetable to view'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _timetableIndex = 1;
                                      localTimetable = {
                                        for (int i = 1; i <= 25; i++)
                                          i.toString(): ""
                                      };
                                      loadServerTimetable();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Timetable 1')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _timetableIndex = 2;
                                      localTimetable = {
                                        for (int i = 1; i <= 25; i++)
                                          i.toString(): ""
                                      };
                                      loadServerTimetable();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Timetable 2')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _timetableIndex = 3;
                                      localTimetable = {
                                        for (int i = 1; i <= 25; i++)
                                          i.toString(): ""
                                      };
                                      loadServerTimetable();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Timetable 3')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _timetableIndex = 4;
                                      localTimetable = {
                                        for (int i = 1; i <= 25; i++)
                                          i.toString(): ""
                                      };
                                      loadServerTimetable();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Timetable 4')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _timetableIndex = 5;
                                      localTimetable = {
                                        for (int i = 1; i <= 25; i++)
                                          i.toString(): ""
                                      };
                                      loadServerTimetable();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Timetable 5')),
                            ],
                          );
                        });
                  })
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) => Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            _buildCell('', height: 50),
                          ]),
                          TableRow(children: [
                            _buildCell('09:00\n10:30'),
                          ]),
                          TableRow(children: [
                            _buildCell('10:40\n12:10'),
                          ]),
                          TableRow(children: [
                            _buildCell('13:00\n14:30'),
                          ]),
                          TableRow(children: [
                            _buildCell('14:40\n16:10'),
                          ]),
                          TableRow(children: [
                            _buildCell('16:20\n17:50'),
                          ])
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: LayoutBuilder(builder: (context, constraints) {
                      double expandedWidth = constraints.maxWidth * 0.2;
                      return Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            _buildCell('Mon', height: 50),
                            _buildCell('Tue', height: 50),
                            _buildCell('Wed', height: 50),
                            _buildCell('Thur', height: 50),
                            _buildCell('Fri', height: 50),
                          ]),
                          // 25 cells in total
                          for (int i = 0; i <= 4; i++)
                            TableRow(children: [
                              for (int j = 1; j <= 5; j++)
                                _buildCell('${i * 5 + j}',
                                    width: expandedWidth, interactable: true)
                            ]),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  BottomInfo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    String cellIndex, {
    double height = 80,
    double width = 50,
    color = Colors.white,
    bool interactable = false,
  }) {
    bool _canHaveEntry = localTimetable.containsKey(cellIndex);
    _openEntryDialog() async {
      final dialogResult = await timetableEntryDialogBuilder(context,
          currentLecture: localTimetable[cellIndex]!,
          currentCellNum: cellIndex);

      if (dialogResult!.isEmpty) return;
      setState(() {
        if (dialogResult.contains('Save'))
          localTimetable[cellIndex] = dialogResult.substring(4);
        else if (dialogResult == 'Delete')
          localTimetable[cellIndex] = "";
        else
          throw Exception('Invalid dialogResult');
      });
    }

    return Container(
      color: color,
      width: width,
      height: height,
      // if text matches cellNow, it should have the current time indicator
      child: Stack(children: [
        Center(child: Text(cellIndex)),
        // if the cell is a slot and has no entry, it's an interactable white cell,
        // if it has an entry, it has a colored button instead
        if (_canHaveEntry)
          localTimetable[cellIndex]!.isEmpty
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: _openEntryDialog,
                    child: Container(
                        clipBehavior: Clip.none,
                        width: width,
                        height: height,
                        color: Colors.white,
                        child: Text('')),
                  ),
                )
              : Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    clipBehavior: Clip.none,
                    width: width,
                    height: height,
                    child: ElevatedButton(
                        child: Text(
                          localTimetable[cellIndex]!,
                          style: TextStyle(fontSize: 8),
                        ),
                        onPressed: _openEntryDialog,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color((math.Random().nextDouble() * 0xFFFFFF)
                                      .toInt())
                                  .withOpacity(1.0)), // Set the button color
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        )),
                  ),
                ),
        // if the cell is the current time, it should have the current time indicator
        if (cellIndex == '$cellNow')
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: Container(
                  clipBehavior: Clip.none,
                  width: width,
                  height: height,
                  color: Colors.blue.withOpacity(0.3),
                  child: Text('')),
            ),
          ),
      ]),
    );
  }

  void setCurrentTimeSlot() {
    if (time < 900) {
      cellNow = 0;
    } else if (time <= 1030) {
      cellNow = 5 * 0 + day;
    } else if (time <= 1210) {
      cellNow = 5 * 1 + day;
    } else if (time <= 1430) {
      cellNow = 5 * 2 + day;
    } else if (time <= 1610) {
      cellNow = 5 * 3 + day;
    } else if (time <= 1750) {
      cellNow = 5 * 4 + day;
    } else {
      cellNow = 0;
    }
    cellNow = 5 < day ? 0 : cellNow;
  }

  void loadServerTimetable() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          for (String timetable in data['timetables'].keys) {
            if (timetable == "timetable$_timetableIndex") {
              for (String key in data['timetables'][timetable].keys) {
                localTimetable[key] = data['timetables'][timetable][key];
              }
            }
          }
        }

        setState(() {});
      } else {
        print('No documents found for this user');

        uploadLocalTimetable();
      }
    });
  }

  void uploadLocalTimetable() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          doc.reference
              .update({'timetables.timetable$_timetableIndex': localTimetable});
        }
      } else {
        print('No documents found for this user.');
      }
    });
  }
}

class BottomInfo extends StatelessWidget {
  const BottomInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth:
          FixedColumnWidth(MediaQuery.of(context).size.width / 4),
      children: [
        TableRow(children: [
          Text(
            "GPA",
            style: TextStyle(fontSize: 25.0),
          ),
          Text(
            "Credits",
            style: TextStyle(fontSize: 25.0),
          ),
          Text(
            "Notes",
            style: TextStyle(fontSize: 25.0),
            // textAlign: TextAlign.right,
          ),
        ]),
        TableRow(children: [
          TableCell(child: SizedBox(height: 20)),
          TableCell(child: SizedBox(height: 20)),
          TableCell(child: SizedBox(height: 20)),
        ]),
        TableRow(children: [
          TextField(
            controller: TextEditingController()..text = '0.00/0.00',
            style: TextStyle(fontSize: 15.0),
          ),
          TextField(
            controller: TextEditingController()..text = '0/0',
            style: TextStyle(fontSize: 15.0),
          ),
          TextField(
            controller: TextEditingController()..text = 'abc...',
            style: TextStyle(fontSize: 15.0),
            // textAlign: TextAlign.right,
          ),
        ]),
      ],
    );
  }

  void uploadBottomInfo() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'GPA': "2.0/4.5"});
          doc.reference.update({'credits': "80/124"});
          doc.reference.update({'notes': "OK..."});
        }
      } else {
        print('No documents found for this user.');
      }
    });
  }
}
