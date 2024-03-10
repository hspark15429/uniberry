import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/model/app_state.dart';
import 'package:gtk_flutter/screens/Grade/grade_page.dart';
import 'package:gtk_flutter/screens/setupTimetableWidget.dart';
import 'package:gtk_flutter/screens/timetable_menu_page.dart';
import 'package:gtk_flutter/src/timetable_service.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      localTimetableFuture = TimetableService.getServerTimetable(_timetableIndex);
      localTimetableFuture.then((value) {
        setState(() {
          localTimetable = value;
        });
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bottomInfoFuture = TimetableService.getServerBottomInfo();
      bottomInfoFuture.then((value) {
        setState(() {
          bottomInfo = value;
        });
      });
    });
  }

  void updateBottomInfo(int index, String newValue) {
    setState(() {
      bottomInfo[index] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            },
          ),
IconButton(
            icon: const Icon(CupertinoIcons.settings),
            tooltip: 'More options',
            onPressed: () {
              TimetableService.showPicker(context, context.read<ApplicationState>().getSchoolIndex);
            },
          ),
         IconButton(
  icon: const Icon(Icons.add), // 여기서 사용하는 아이콘은 예시입니다.
  tooltip: '시간표 추가',
  onPressed: () => showSetupTimetableDialog(context),
),
          IconButton(
            icon: const Icon(CupertinoIcons.bars),
            tooltip: '時間割リスト',
            onPressed: () async {
              final int? selectedTimetableIndex = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimetableMenuPage()),
              );
              if (selectedTimetableIndex != null) {
                timetableSwitch(context, index: selectedTimetableIndex);
              }
            },
          ),
        ],
      ),
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
            SizedBox(height: 10),
            buildAcademicStatusBox(),
            MyBox(
              title: "Notes",
              content: bottomInfo[2],
              onUpdate: (newValue) => updateBottomInfo(2, newValue),
            ),
          ],
        ),
      ),
    );
  }
 void showSetupTimetableDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: SetupTimetableWidget(), // SetupTimetableWidget을 여기에 포함시킵니다.
          ),
        ),
      );
    },
  );
}



  Future<void> timetableSwitch(BuildContext context, {required int index}) async {
    context.read<ApplicationState>().timetableIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timetableIndex', index);
    _timetableIndex = index;
    final _newTimetable = await TimetableService.getServerTimetable(_timetableIndex);
    setState(() {
      localTimetable = _newTimetable;
    });
    Navigator.of(context).pop();
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
          localTimetable[cellIndex] = (dialogResult.substring(4)).toString();
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
      child: Stack(children: [
        Center(child: Text(cellIndex, style: TextStyle(color: Colors.black))),
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
                          localTimetable[cellIndex]!.split('|')[0].toString(),
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
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        )),
                  ),
                ),
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

  Widget buildAcademicStatusBox() {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GradePage())),
    child: Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('履修状況', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GradePage())),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('累積GPA: 4.2/5.0', style: TextStyle(fontSize: 16)),
          Text('取得単位: 89/124', style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}


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
    "2025年秋学期",
    ""
  ];
  return _timetableList[index];
}
}