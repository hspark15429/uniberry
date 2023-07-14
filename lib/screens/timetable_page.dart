import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, bool> cellTaps = {};
  String cellNow = 'Cell 13';

  Widget _buildCell(String text,
      {double height = 120, double width = 100, color = Colors.white}) {
    return GestureDetector(
      onTap: () {
        // open pop up window to add event
        setState(() {
          cellTaps[text] = true;
        });
      },
      child: Container(
        color: color,
        width: width,
        height: height,
        // if text matches cellNow, it should have the current time indicator
        child: text == cellNow
            ? Stack(
                children: [
                  Center(child: Text(text)),
                  Positioned(
                    top: height / 2,
                    left: 0,
                    child: Container(
                      clipBehavior: Clip.none,
                      width: width * 3,
                      height: 4,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            : Center(child: Text(text)),
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
                  final now = DateTime.now();
                  print(now);
                  return Table(
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
                        _buildCell('Cell 2'),
                        _buildCell('Cell 3'),
                        _buildCell('Cell 4'),
                        _buildCell('Cell 5'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 6'),
                        _buildCell('Cell 7'),
                        _buildCell('Cell 8',
                            color: cellTaps['Cell 9'] == true
                                ? Colors.green
                                : Colors.white),
                        _buildCell('Cell 9'),
                        _buildCell('Cell 10'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 11'),
                        _buildCell('Cell 12'),
                        _buildCell('Cell 13'),
                        _buildCell('Cell 14'),
                        _buildCell('Cell 15'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 16'),
                        _buildCell('Cell 17'),
                        _buildCell('Cell 18',
                            color: cellTaps['Mon'] == true
                                ? Colors.green
                                : Colors.white),
                        _buildCell('Cell 19'),
                        _buildCell('Cell 20'),
                      ]),
                      TableRow(children: [
                        _buildCell('Cell 21'),
                        _buildCell('Cell 22'),
                        _buildCell('Cell 23'),
                        _buildCell('Cell 24'),
                        _buildCell('Cell 25'),
                      ])
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