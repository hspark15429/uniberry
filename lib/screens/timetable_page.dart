import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late ApplicationState appState;
  late Map<String, String> cellTaps;
  int cellNow = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<ApplicationState>(context);
    cellTaps = appState.cellTaps;
  }

  @override
  void initState() {
    super.initState();
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
          title: Text('Timetable'),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Row(
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
                flex: 10,
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
        ),
      ),
    );
  }

  Widget _buildCell(
    String cellIndex, {
    double height = 120,
    double width = 100,
    color = Colors.white,
    bool interactable = false,
  }) {
    // bool _hasEntry = cellTaps[cellIndex]!.isNotEmpty;
    bool _canHaveEntry = cellTaps.containsKey(cellIndex);
    _openEntryDialog() async {
      final dialogResult = await timetableEntryDialogBuilder(context,
          currentLecture: cellTaps[cellIndex]!, currentCellNum: cellIndex);

      if (dialogResult!.isEmpty) return;
      setState(() {
        if (dialogResult.contains('Save'))
          cellTaps[cellIndex] = dialogResult.substring(4);
        else if (dialogResult == 'Delete')
          cellTaps[cellIndex] = "";
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
          cellTaps[cellIndex]!.isEmpty
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
                        child: Text(cellTaps[cellIndex]!),
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
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      cellTaps = appState.cellTaps;
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          for (String key in data['currentTimetable'].keys) {
            cellTaps[key] = data['currentTimetable'][key];
          }
        }
        setState(() {});
      } else {
        print('No documents found for this user');
        cellTaps = appState.cellTaps;
        uploadLocalTimetable();
      }
    });
  }

  void uploadLocalTimetable() {
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'currentTimetable': cellTaps});
        }
      } else {
        print('No documents found for this user.');
      }
    });
  }
}
