import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/model/app_state.dart';
import 'package:gtk_flutter/src/timetable_service.dart';
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
  late int _timetableIndex;

  // late ApplicationState appState;
  late Future<Map<String, String>> localTimetableFuture;
  late Map<String, String> localTimetable = {
    for (int i = 1; i <= 25; i++) i.toString(): ""
  };
  late int cellNow;
  late Future<List<String>> bottomInfoFuture;
  late List<String> bottomInfo = ["", "", ""];
  bool _isEnable = false;
  late int selectedSchool = 0;

  @override
  void initState() {
    super.initState();
    _timetableIndex = context.read<ApplicationState>().timetableIndex;
    cellNow = TimetableService.getCurrentTimeSlot();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      localTimetableFuture =
          TimetableService.getServerTimetable(_timetableIndex);
      localTimetableFuture.then((value) {
        setState(() {
          localTimetable = value;
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bottomInfoFuture = TimetableService.getServerBottomInfo();
      bottomInfoFuture.then((value) {
        setState(() {
          bottomInfo = value;
        });
      });
    });
    // loadServerBottomInfo();
  }

  @override
  Widget build(BuildContext context) {
    // save current timetable to firestore
    // TimetableService.uploadTimetable(
    //   timetable: localTimetable,
    //   index: _timetableIndex,
    // );
    // TimetableService.uploadBottomInfo(bottomInfo);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            getTimetableByIndex(_timetableIndex),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 30, 30),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: const Icon(Icons.cleaning_services_outlined),
                tooltip: 'Clean up',
                onPressed: () {
                  setState(() {
                    localTimetable = {
                      for (int i = 1; i <= 25; i++) i.toString(): ""
                    };
                    TimetableService.uploadTimetable(
                      timetable: localTimetable,
                      index: _timetableIndex,
                    );
                  });
                }),
            IconButton(
                icon: const Icon(CupertinoIcons.settings),
                tooltip: 'More options',
                onPressed: () {
                  // handle the press
                  TimetableService.showPicker(
                      context, context.read<ApplicationState>().getSchoolIndex);
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (builder) {
                  //       return Wrap(
                  //         children: [
                  //           ListTile(
                  //             leading: Icon(Icons.settings),
                  //             title: Text('Select Major'),
                  //             onTap: () {
                  //               selectedMajor =
                  //                   TimetableService.showPicker(context, 0);
                  //             },
                  //           ),
                  //           // ListTile(
                  //           //   leading: Icon(Icons.copy),
                  //           //   title: Text('Copy Link'),
                  //           // ),
                  //           // ListTile(
                  //           //   leading: Icon(Icons.edit),
                  //           //   title: Text('Edit'),
                  //           // ),
                  //         ],
                  //       );
                  //     });
                }),
            IconButton(
                icon: const Icon(CupertinoIcons.bars),
                tooltip: '時間割リスト',
                onPressed: () {
                  // handle the press
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('時間割リスト'),
                          content: Text('時間割リストから選択 '),
                          actions: List<Widget>.generate(
                            6,
                            (index) => TextButton(
                              onPressed: () =>
                                  timetableSwitch(context, index: index + 1),
                              child: Text(getTimetableByIndex(index)),
                            ),
                          ),
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
                          _buildCell('月', height: 50),
                          _buildCell('火', height: 50),
                          _buildCell('水', height: 50),
                          _buildCell('木', height: 50),
                          _buildCell('金', height: 50),
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
            Consumer<ApplicationState>(builder: (context, appState, _) {
              List<String> _schoolList = ["経営学部", "総合心理学部", "政策科学部"];
              return Text(
                "専攻: ${_schoolList[appState.schoolIndex]}",
                textAlign: TextAlign.start,
              );
            }),
            SizedBox(height: 20),
            SafeArea(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Table(
                    border: TableBorder.all(),
                    defaultColumnWidth:
                        FixedColumnWidth(MediaQuery.of(context).size.width / 5),
                    children: [
                      TableRow(children: [
                        Text(
                          "GPA",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "単位",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Notes",
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                      TableRow(children: [
                        TextField(
                          onSubmitted: (value) => {
                            bottomInfo[0] = value,
                            setState(() {
                              TimetableService.uploadBottomInfo(bottomInfo);
                            })
                          },
                          controller: TextEditingController()
                            ..text = bottomInfo[0],
                          style: TextStyle(fontSize: 15.0),
                        ),
                        TextField(
                          onSubmitted: (value) => {
                            bottomInfo[1] = value,
                            setState(() {
                              TimetableService.uploadBottomInfo(bottomInfo);
                            })
                          },
                          controller: TextEditingController()
                            ..text = bottomInfo[1],
                          style: TextStyle(fontSize: 15.0),
                        ),
                        TextField(
                          onSubmitted: (value) => {
                            bottomInfo[2] = value,
                            setState(() {
                              TimetableService.uploadBottomInfo(bottomInfo);
                            })
                          },
                          controller: TextEditingController()
                            ..text = bottomInfo[2],
                          style: TextStyle(fontSize: 15.0),
                          // textAlign: TextAlign.right,
                        ),
                      ]),
                    ],
                  ),
                  SizedBox(width: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> timetableSwitch(BuildContext context,
      {required int index}) async {
    {
      context.read<ApplicationState>().timetableIndex = index;
      _timetableIndex = index;
      final _newTimetable =
          await TimetableService.getServerTimetable(_timetableIndex);
      setState(() {
        localTimetable = _newTimetable;
      });
      Navigator.of(context).pop();
    }
  }

  String truncate(String text, {length = 30, omission = '...'}) {
    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  Widget _buildCell(
    String cellIndex, {
    double height = 87,
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
          localTimetable[cellIndex] =
              (dialogResult.substring(4)).split('|')[0].toString();
        else if (dialogResult == 'Delete')
          localTimetable[cellIndex] = "";
        else
          throw Exception('Invalid dialogResult');
        TimetableService.uploadTimetable(
          timetable: localTimetable,
          index: _timetableIndex,
        );
      });
    }

    return Container(
      color: color,
      width: width,
      height: height,
      // if text matches cellNow, it should have the current time indicator
      child: Stack(children: [
        Center(child: Text(cellIndex, style: TextStyle(color: Colors.black))),
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
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: _openEntryDialog,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              getColorByIndex(int.parse(cellIndex))),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
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
}

// Function to get a color by index
Color getColorByIndex(int index) {
  return colors[index % colors.length];
}

List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.redAccent,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.deepPurpleAccent,
  Colors.indigoAccent,
  Colors.blueAccent
];

String getTimetableByIndex(int index) {
  List<String> _timetableList = [
    "2023年春学期",
    "2023年秋学期",
    "2024年春学期",
    "2024年秋学期",
    "2025年春学期",
    "2025年春学期"
  ];
  return _timetableList[index];
}
