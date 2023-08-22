import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/model/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimetableService {
  static int getCurrentTimeSlot() {
    int day = DateTime.now().weekday;
    int time = int.parse(DateFormat('HHmm').format(DateTime.now()));
    if (time < 900 || day > 5) {
      return 0;
    } else if (time <= 1030) {
      return 5 * 0 + day;
    } else if (time <= 1210) {
      return 5 * 1 + day;
    } else if (time <= 1430) {
      return 5 * 2 + day;
    } else if (time <= 1610) {
      return 5 * 3 + day;
    } else if (time <= 1750) {
      return 5 * 4 + day;
    } else {
      return 0;
    }
  }

  static Future<Map<String, String>> getServerTimetable(int index) async {
    Map<String, String> serverTimetable = {
      for (int i = 1; i <= 25; i++) i.toString(): ""
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        for (String timetable in data['timetables'].keys) {
          if (timetable == "timetable$index") {
            for (String key in data['timetables'][timetable].keys) {
              serverTimetable[key] = data['timetables'][timetable][key];
            }
          }
        }
      }
    } else {
      print('No documents found for this user');
      uploadTimetable(index: index, timetable: serverTimetable);
    }

    return serverTimetable;
  }

  static Future<List<String>> getServerBottomInfo() async {
    List<String> bottomInfo = ["0.00/0.00", "0/0", "abc..."];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        bottomInfo[0] = data['GPA'];
        bottomInfo[1] = data['credits'];
        bottomInfo[2] = data['notes'];
      }
    } else {
      print('No documents found for this user');
      uploadBottomInfo(bottomInfo);
    }
    return bottomInfo;
  }

  static void uploadBottomInfo(bottomInfo, {int index = -1}) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        if (index >= 0) {
          for (var doc in querySnapshot.docs) {
            switch (index) {
              case 0:
                doc.reference.update({'GPA': bottomInfo});
              case 1:
                doc.reference.update({'credits': bottomInfo});
              case 2:
                doc.reference.update({'notes': bottomInfo});
            }
          }
        } else {
          for (var doc in querySnapshot.docs) {
            doc.reference.update({'GPA': bottomInfo[0]});
            doc.reference.update({'credits': bottomInfo[1]});
            doc.reference.update({'notes': bottomInfo[2]});
          }
        }
      } else {
        print('No documents found for this user.');
      }
    });
  }

  static void uploadTimetable(
      {required int index, required Map<String, String> timetable}) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'timetables.timetable$index': timetable});
        }
      } else {
        print('No documents found for this user.');
      }
    });
  }

  static int showPicker(BuildContext context, int currentMajor) {
    int _selectedMajor = currentMajor;
    showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
              width: 300,
              height: 250,
              child: CupertinoPicker(
                // backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController:
                    FixedExtentScrollController(initialItem: currentMajor),
                children: const [
                  Text("法学部"),
                  Text("経済学部"),
                  Text("経営学部"),
                  Text("産業社会学部"),
                  Text("国際関係学部"),
                  Text("政策科学部"),
                  Text("文学部"),
                  Text("映像学部"),
                  Text("総合心理学部"),
                  Text("理工学部"),
                  Text("グローバル教養学部"),
                  Text("食マネジメント学部"),
                  Text("情報理工学部"),
                  Text("生命科学部"),
                  Text("薬学部"),
                  Text("スポーツ健康科学部"),
                  Text("法学研究科"),
                  Text("経済学研究科"),
                  Text("経営学研究科"),
                  Text("社会学研究科"),
                  Text("国際関係研究科"),
                  Text("政策科学研究科"),
                  Text("文学研究科"),
                  Text("映像研究科"),
                  Text("理工学研究科"),
                  Text("情報理工学研究科"),
                  Text("生命科学研究科"),
                  Text("薬学研究科"),
                  Text("スポーツ健康科学研究科"),
                  Text("応用人間科学研究科"),
                  Text("先端総合学術研究科"),
                  Text("言語教育情報研究科"),
                  Text("法務研究科"),
                  Text("テクノロジー・マネジメント研究科"),
                  Text("経営管理研究科"),
                  Text("公務研究科"),
                  Text("教職研究科"),
                  Text("人間科学研究科"),
                  Text("食マネジメント研究科"),
                ],
                onSelectedItemChanged: (value) {
                  _selectedMajor = value;
                  context.read<ApplicationState>().setSchoolIndex = value;
                },
              ),
            ));
    return _selectedMajor;
  }
}
