import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];
  final day;
  final period;

  CustomSearchDelegate({required this.day, required this.period}) {
    loadSearchTerms();
  }

  Future<void> loadSearchTerms() async {
    String jsonString =
        await rootBundle.loadString('../../assets/lectures.json');

    List<dynamic> lectureData = jsonDecode(jsonString);

    for (var lecture in lectureData) {
      if (day == lecture['day'] && period == lecture['period']) {
        String term =
            "${lecture['title']} | ${lecture['lecturer']} | ${lecture['lecturer code']}";
        searchTerms.add(term);
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
          close(context, null);
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

// Future dialogBuilder
//
