import 'package:flutter/material.dart';

class EditableBox extends StatefulWidget {
  final String text;
  final Function(String) onSave;

  EditableBox({required this.text, required this.onSave});

  @override
  _EditableBoxState createState() => _EditableBoxState();
}

class _EditableBoxState extends State<EditableBox> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: isEditing
                ? TextField(
                    controller: _controller,
                  )
                : Text(_controller.text),
          ),
          if (isEditing) ...[
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _controller.text = widget.text;
                    isEditing = false;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  setState(() {
                    widget.onSave(_controller.text);
                    isEditing = false;
                  });
                },
              ),
            ),
          ] else
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
