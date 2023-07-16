import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];
  final cellText;

  CustomSearchDelegate({required this.cellText}) {
    loadSearchTerms();
    // print(cellText);
  }

  Future<void> loadSearchTerms() async {
    String jsonString = await rootBundle.loadString('assets/lectures.json');

    List<dynamic> lectureData = jsonDecode(jsonString);

    for (var lecture in lectureData) {
      if (lecture['periods'][0].isNotEmpty) {
        if (lecture['periods']
            .map((period) => convertPeriodToInt(period))
            .toList()
            .contains(int.parse(cellText))) {
          String term =
              "${lecture['course']['titles']} | ${lecture['professors']} | ${lecture['codes']}";
          searchTerms.add(term);
        }
      }
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
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
          title: Text(result),
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
          title: Text(result),
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
