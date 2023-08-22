import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gtk_flutter/model/app_state.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];
  final cellText;
  late List<dynamic> lectureData;

  CustomSearchDelegate({required this.cellText}) {
    // print(cellText);
  }

  Future<void> loadSearchTerms(BuildContext context) async {
    String jsonString = await rootBundle.loadString('assets/lectures.json');

    List<dynamic> lectureData = jsonDecode(jsonString);

    var appState = Provider.of<ApplicationState>(context, listen: false);
    int _schoolIndex = appState.getSchoolIndex;
    // 경영학과, 심리학과, 정책학과
    List<String> _schoolList = [
      "法学部",
      "経済学部",
      "経営学部",
      "産業社会学部",
      "国際関係学部",
      "政策科学部",
      "文学部",
      "映像学部",
      "総合心理学部",
      "理工学部",
      "グローバル教養学部",
      "食マネジメント学部",
      "情報理工学部",
      "生命科学部",
      "薬学部",
      "スポーツ健康科学部",
      "法学研究科",
      "経済学研究科",
      "経営学研究科",
      "社会学研究科",
      "国際関係研究科",
      "政策科学研究科",
      "文学研究科",
      "映像研究科",
      "理工学研究科",
      "情報理工学研究科",
      "生命科学研究科",
      "薬学研究科",
      "スポーツ健康科学研究科",
      "応用人間科学研究科",
      "先端総合学術研究科",
      "言語教育情報研究科",
      "法務研究科",
      "テクノロジー・マネジメント研究科",
      "経営管理研究科",
      "公務研究科",
      "教職研究科",
      "人間科学研究科",
      "食マネジメント研究科",
    ];

    for (var lecture in lectureData) {
      if (lecture['periods'][0].isNotEmpty) {
        // print(lecture['periods'][0]);
        if (lecture['periods']
            .map((period) => convertPeriodToInt(period))
            .toList()
            .contains(int.parse(cellText))) {
          String term =
              "${lecture['course']['titles']} | ${lecture['professors']} | ${lecture['codes']}@${lecture['course']['href']}";
          if (lecture['schools'].contains(_schoolList[_schoolIndex]) &&
              lecture['term'].contains('秋セメスター')) searchTerms.add(term);
        }
      }
    }
    searchTerms = searchTerms.toSet().toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    loadSearchTerms(context);
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var lecture in searchTerms) {
      if (lecture.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(lecture);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.split('@')[0]),
          onTap: () => close(context, result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var lecture in searchTerms) {
      if (lecture.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(lecture);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.split('@')[0]),
          onTap: () => close(context, result),
        );
      },
    );
  }
}

// this method converts string to int. Example: 月, 火, 水, 木, 金 as 1, 2, 3, 4, 5
int convertPeriodToInt(String period) {
  int day = 0;
  int timeslot;
  switch (period[0]) {
    case '月':
      day = 1;
    case '火':
      day = 2;
    case '水':
      day = 3;
    case '木':
      day = 4;
    case '金':
      day = 5;
  }
  timeslot = int.parse(period[1]);
  return (timeslot - 1) * 5 + day;
}
