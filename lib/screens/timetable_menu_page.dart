import 'package:flutter/material.dart';

class TimetableMenuPage extends StatefulWidget {
  @override
  _TimetableMenuPageState createState() => _TimetableMenuPageState();
}

class _TimetableMenuPageState extends State<TimetableMenuPage> {
  List<String> _timetableList = [
    "2024年春学期",
    "2024年秋学期",
    "2025年春学期",
    "2025年秋学期",
    "2026年春学期",
    "2026年秋学期",
  ];

  String? _recentlyDeletedTimetable;
  int? _recentlyDeletedTimetablePosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('時間割リスト'),
      ),
      body: ListView.builder(
        itemCount: _timetableList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_timetableList[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _recentlyDeletedTimetable = _timetableList[index];
              _recentlyDeletedTimetablePosition = index;

              setState(() {
                _timetableList.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('削除されました'),
                  action: SnackBarAction(
                    label: '復元する',
                    onPressed: () {
                      if (_recentlyDeletedTimetablePosition != null && _recentlyDeletedTimetable != null) {
                        setState(() {
                          _timetableList.insert(_recentlyDeletedTimetablePosition!, _recentlyDeletedTimetable!);
                        });
                        _recentlyDeletedTimetable = null;
                        _recentlyDeletedTimetablePosition = null;
                      }
                    },
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(_timetableList[index]),
             onTap: () {
              Navigator.pop(context, index); 
                },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _displayEditDialog(context, index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayEditDialog(BuildContext context, int index) async {
    TextEditingController _controller = TextEditingController(text: _timetableList[index]);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('タイトル変更'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '新しい名前を作成してください'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('保存'),
              onPressed: () {
                setState(() {
                  _timetableList[index] = _controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('取り消し'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayAddDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新しい時間割を追加'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'タイトル名'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('追加'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _timetableList.add(_controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('取り消し'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
