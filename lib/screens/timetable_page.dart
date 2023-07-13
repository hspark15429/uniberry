import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, bool> cellTaps = {};

  Widget _buildCell(String text,
      {double height = 120, double width = 100, color = Colors.white}) {
    return GestureDetector(
      onTap: () {
        print(text);
        setState(() {
          cellTaps[text] = true;
          print(cellTaps);
        });
      },
      child: Container(
        color: color,
        width: width,
        height: height,
        child: Center(child: Text(text)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Timetable'),
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
                        _buildCell('10:40\12:10'),
                      ]),
                      TableRow(children: [
                        _buildCell('13:00\14:30'),
                      ]),
                      TableRow(children: [
                        _buildCell('14:40\16:10'),
                      ]),
                      TableRow(children: [
                        _buildCell('16:20\17:50'),
                      ])
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: LayoutBuilder(
                  builder: (context, constraints) => Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        _buildCell('Mon',
                            height: 50,
                            color: cellTaps['Mon'] == true
                                ? Colors.green
                                : Colors.white),
                        _buildCell('Tue', height: 50),
                        _buildCell('Wed', height: 50),
                        _buildCell('Thur', height: 50),
                        _buildCell('Fri', height: 50),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1',
                            color: cellTaps['Cell 1'] == true
                                ? Colors.green
                                : Colors.white),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1',
                            color: cellTaps['Mon'] == true
                                ? Colors.green
                                : Colors.white),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                        _buildCell('Cell 1'),
                      ])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
