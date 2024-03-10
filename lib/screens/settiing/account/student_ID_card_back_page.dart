import 'dart:math' as math;

import 'package:flutter/material.dart';

class StudentIDCardBackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/qrcodeex.png'),
          ),
            Text('학생 번호: 905750250'),
            Text('이름: PARK JAEJIN'),
            Text('소속: 경영학부'),
            Text('현재 주소: [학생의 주소]'),
            Text('정기권 사용 기간: [시작일] - [종료일]'),
          ],
        ),
      ),
    );
  }
}
