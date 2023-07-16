import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Map<String, String> cellTaps = {};
  int cellNow = 0;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
                  final now = DateTime.now();
                  print(now);
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

  Widget _buildCell(String text,
      {double height = 120,
      double width = 100,
      color = Colors.white,
      bool interactable = false}) {
    return GestureDetector(
      onTap: () async {
        // open pop up window to add event
        // dialogBuilder passes in the selected time slot's day and period
        final result = await dialogBuilder(
            context,
            "",
            (int.parse(text) % 5) != 0 ? (int.parse(text) % 5) : 5,
            ((int.parse(text) - 1) ~/ 5) + 1);

        if (result!.contains('Save')) {
          setState(() {
            cellTaps[text] = result.substring(4);
          });
        } else if (result == 'Delete') {
          setState(() {
            cellTaps[text] = "";
          });
        }
        print(result);
      },
      child: Container(
        color: color,
        width: width,
        height: height,
        // if text matches cellNow, it should have the current time indicator
        child: Stack(children: [
          Center(child: Text(text)),
          if (text == '$cellNow')
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: Container(
                    clipBehavior: Clip.none,
                    width: width,
                    height: height,
                    color: Colors.blue,
                    child: Text('')),
              ),
            ),
          if (cellTaps[text] != null && interactable)
            if (cellTaps[text]!.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  clipBehavior: Clip.none,
                  width: width,
                  height: height * 1,
                  child: ElevatedButton(
                      child: Text(cellTaps[text]!),
                      onPressed: () async {
                        final result = await dialogBuilder(
                            context,
                            cellTaps[text]!,
                            (int.parse(text) % 5) != 0
                                ? (int.parse(text) % 5)
                                : 5,
                            ((int.parse(text) - 1) ~/ 5) + 1);
                        if (result!.contains('Save')) {
                          setState(() {
                            cellTaps[text] = result.substring(4);
                          });
                        } else if (result == 'Delete') {
                          setState(() {
                            cellTaps[text] = "";
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
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
        ]),
      ),
    );
  }
}

// var array = List<List<String>>.generate(
//   5,
//   (i) => List<String>.generate(
//     5,
//     (j) => 'Cell ${i * 5 + j + 1}',
//   ),
// );

// if (istimeNow){
//   position(
//     top: (controller.cellHeight*0.5)
//     left: cellWidth*Day
//   )

// }

//       if (number >= 900 && number <= 1030) {
//       print('The number is between 1000 and 2000.');
//     }