import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:image_picker/image_picker.dart';

class ThreadWritePage extends StatefulWidget {
  const ThreadWritePage({Key? key}) : super(key: key);

  @override
  _ThreadWritePageState createState() => _ThreadWritePageState();
}

class _ThreadWritePageState extends State<ThreadWritePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<String> _categories = BoardType.values.map((type) => boardTypeToString(type)).toList();
  BoardType? _selectedBoardType;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 작성'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
  value: _selectedBoardType != null ? boardTypeToString(_selectedBoardType!) : null,
  hint: Text('카테고리 선택'),
  onChanged: (String? newValue) {
    setState(() {
      _selectedBoardType = BoardType.values.firstWhere((type) => boardTypeToString(type) == newValue);
    });
  },
  items: _categories.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
),
  
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '본문',
              ),
              maxLines: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '본문을 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            _image != null ? Image.file(File(_image!.path)) : SizedBox(),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('이미지 추가'),
            ),
            ElevatedButton(
             onPressed: () {
  if (_formKey.currentState!.validate()) {
    // 예: 더미 데이터 목록에 추가하는 대신 실제 애플리케이션에서는 이 정보를 서버에 전송하거나 로컬 데이터베이스에 저장합니다.
    // 예시 코드는 실제 데이터 추가를 반영하지 않습니다.
    Navigator.pop(context); // 게시물 작성 후 이전 페이지로 돌아감
  }
},
              child: Text('게시물 작성'),
            ),
          ],
        ),
      ),
    );
  }
}
