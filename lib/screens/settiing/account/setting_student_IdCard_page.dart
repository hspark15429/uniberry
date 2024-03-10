import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'student_ID_card_back_page.dart';
import 'student_ID_card_front_page.dart';

class NFCServices {
  Future<String> readNFC() async {
    String result = '';

    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        result = 'NFC 기능을 사용할 수 없습니다.';
        return result;
      }

      NFCTag tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));
      result = tag.id;
    } on Exception catch (e) {
      result = 'NFC 태그를 읽는 중 에러가 발생했습니다: $e';
    }

    return result;
  }
}

class SettingStudentIdCardPage extends StatefulWidget {
  @override
  _SettingStudentIdCardPageState createState() =>
      _SettingStudentIdCardPageState();
}

class _SettingStudentIdCardPageState extends State<SettingStudentIdCardPage> {
  bool isFront = true;
  String nfcData = '';
  NFCServices nfcServices = NFCServices();

  void toggleCardSide() {
    setState(() {
      isFront = !isFront;
    });
  }

  void scanNFC() async {
    String data = await nfcServices.readNFC();
    setState(() {
      nfcData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학생증 설정'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isFront ? Icons.flip_to_back : Icons.flip_to_front), // 전면/후면 아이콘 토글
            onPressed: toggleCardSide,
          ),
          IconButton(
            icon: Icon(Icons.nfc),
            onPressed: scanNFC,
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: isFront
              ? StudentIDCardFrontPage()
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: StudentIDCardBackPage(),
                ),
        ),
      ),
    );
  }
}
