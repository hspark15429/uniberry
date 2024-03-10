import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/settiing/account/setting_pw_change_page.dart';
import 'package:gtk_flutter/screens/settiing/account/setting_student_IdCard_page.dart';
import 'package:gtk_flutter/screens/settiing/account/setting_user_id_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account/setting_email_change_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false; // 다크모드 상태를 관리하는 변수

  _launchUniberryHomepage() async {
    const url = 'https://www.uniberry.site';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchUniberryContactPage() async {
    const url = 'https://invited-play-8a9.notion.site/8e4789aab735468db7577b77681cb103';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchPrivacyPolicy() async {
    const url = 'https://invited-play-8a9.notion.site/5929b4597a184a3fb0cbf59637de6a60';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 계정 섹션
          ListTile(
            title: const Text(
              '계정',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('학생증 인증'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingStudentIdCardPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('이메일'),
            subtitle: const Text('hspark15429@ed.ritsumei.ac.jp'),
          ),
         ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('이메일 변경'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingEmailChangePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('유저 아이디 설정'),
            onTap: () {
              // 유저 아이디 설정 페이지로 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingUserIdPage()));
            },
          ),
         ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('비밀번호 변경'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPwChangePage()));
            },
          ),
          
          // 앱 설정 섹션
          ListTile(
            title: const Text(
              '앱 설정',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_round),
            title: const Text('다크모드'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                  // 여기에 다크모드 상태 변경 로직을 추가
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('앱 알림'),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('테마 색상'),
            onTap: () {
              // 테마 색상 변경 기능 추가
            },
          ),
          
          // 앱 정보 섹션
          ListTile(
            title: const Text(
              '앱 정보',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('앱 버전'),
            subtitle: const Text('1.2'),
          ),
          
          // 문의 섹션
          ListTile(
            title: const Text(
              '문의',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Uniberry에게 문의하기'),
            onTap: _launchUniberryContactPage,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Uniberry 홈페이지'),
            onTap: _launchUniberryHomepage,
          ),
          
          // 개인정보 처리 방침
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('개인정보 처리 방침'),
            onTap: _launchPrivacyPolicy,
          ),
        ],
      ),
    );
  }
}
