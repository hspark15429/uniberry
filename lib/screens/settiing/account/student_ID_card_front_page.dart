import 'package:flutter/material.dart';

class StudentIDCardFrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20), // 학교 사진과 학생 정보 사이의 간격
        Image.asset(
          'assets/立命館1.jpg',
          height: 100, // 학교 사진의 높이 조정
        ),
        SizedBox(height: 20), // 학교 사진과 학생증 사이의 간격
        CircleAvatar(
          backgroundImage: AssetImage('assets/PARKJAEJIN.jpg'),
          radius: 50.0,
        ),
        SizedBox(height: 8),
        Text(
          'PARK JAEJIN',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('학생 번호: 905750250'),
        Text('학부: 경영학부'),
        Text('생년월일: 2000.04.17'),
        Text('이메일: email@ed.ritsumei.ac.jp'),
        Text('입학 년도: 2020년'),
        Text('立命館大学'),
      ],
    );
  }
}
