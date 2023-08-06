import 'package:flutter/material.dart';

class MyCustomLayout extends StatelessWidget {
  const MyCustomLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _buildTableRow("Header 1", flex: 1),
                _buildTableRow("Content 1", flex: 2),
                _buildTableRow("Header 2", flex: 1),
                _buildTableRow("Content 2", flex: 2),
                _buildTableRow("Header 3", flex: 1),
                _buildTableRow("Content 3", flex: 2),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _buildTableRow("Row 1", flex: 1),
                _buildTableRow("Row 2", flex: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String text, {required int flex}) {
    return TableRow(
      children: [
        FractionallySizedBox(
          heightFactor: flex.toDouble() / 3,
          child: Container(
            color: Colors.lightBlue,
            child: Center(child: Text(text)),
          ),
        ),
      ],
    );
  }
}
