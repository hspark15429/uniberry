import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupTimetableWidget extends StatefulWidget {
  @override
  _SetupTimetableWidgetState createState() => _SetupTimetableWidgetState();
}

class _SetupTimetableWidgetState extends State<SetupTimetableWidget> {
  List<bool> daysSelected = [true, true, true, true, true, false, false]; // 월요일부터 금요일까지 기본 선택
  int numberOfPeriods = 5;
  final int maxPeriods = 8;
  Map<int, Map<String, TimeOfDay?>> periodTimes = {}; // 교시별 시작 및 종료 시간 저장
  final PageController _pageController = PageController();

  // 알림 설정을 저장할 Map
  Map<String, Map<int, Map<String, TimeOfDay>>> notificationSettings = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Center(child: Text('시간표 추가')),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 요일 선택
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                children: <Widget>[
                  for (var day in ["월", "화", "수", "목", "금", "토", "일"])
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text(day)),
                ],
                isSelected: daysSelected,
                onPressed: (int index) {
                  setState(() {
                    daysSelected[index] = !daysSelected[index];
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            // 교시 수 설정
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (numberOfPeriods > 1) {
                      setState(() {
                        numberOfPeriods--;
                        // 교시 수가 변경되면 periodTimes도 함께 조정
                        periodTimes.remove(numberOfPeriods);
                      });
                    }
                  },
                ),
                Text("교시 수: $numberOfPeriods"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (numberOfPeriods < maxPeriods) {
                      setState(() {
                        numberOfPeriods++;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('최대 교시 수는 $maxPeriods 입니다.')),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // 스와이프 가능한 페이지 뷰
            Container(
              height: 200,
              child: PageView(
                controller: _pageController,
                children: [
                  buildTimeSettingPage(),
                  buildPeriodSettingPage(),
                ],
              ),
            ),
            SizedBox(height: 8),
            // 페이지 인디케이터
            SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: WormEffect(),
              onDotClicked: (index) {
                _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('저장'),
          onPressed: () {
            // 알림 설정을 저장

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

 

  // 요일 이름 가져오는 함수
  String getDayName(int index) {
    switch (index) {
      case 0:
        return '월';
      case 1:
        return '화';
      case 2:
        return '수';
      case 3:
        return '목';
      case 4:
        return '금';
      case 5:
        return '토';
      case 6:
        return '일';
      default:
        return '';
    }
  }
Widget buildTimeSettingPage() {
  return ListView.builder(
    itemCount: numberOfPeriods,
    itemBuilder: (context, index) => ListTile(
      title: Text('교시 ${index + 1}'),
      subtitle: Row(
        children: [
          Expanded( // 이 부분을 추가하여 Row를 감싸줍니다.
            child: ElevatedButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: periodTimes[index]?.values.first ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    periodTimes.putIfAbsent(index, () => {}); // Make sure the inner map is initialized
                    periodTimes[index]!['start'] = picked;
                    if (periodTimes[index]!.containsKey('end')) {
                      if (picked.hour > periodTimes[index]!['end']!.hour || (picked.hour == periodTimes[index]!['end']!.hour && picked.minute > periodTimes[index]!['end']!.minute)) {
                        // Selected start time is later than end time, set end time to start time
                        periodTimes[index]!['end'] = picked;
                      }
                    } else {
                      // End time not selected, set it to start time
                      periodTimes[index]!['end'] = picked;
                    }
                  });
                }
              },
              child: Text('${periodTimes[index]?.values.first?.format(context) ?? '선택'} ~ ${periodTimes[index]?.values.last?.format(context) ?? '선택'}'),
            ),
          ),
        ],
      ),
    ),
  );
}





  Widget buildPeriodSettingPage() {
    return ListView.builder(
      itemCount: numberOfPeriods,
      itemBuilder: (context, index) => ListTile(
        title: Text('교시 ${index + 1}'),
      ),
    );
  }
}
