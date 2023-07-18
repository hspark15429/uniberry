import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/search_page.dart';
import 'package:gtk_flutter/src/widgets.dart';

Future<String?> timetableEntryDialogBuilder(
  BuildContext context, {
  required String currentLecture,
  required String currentCellNum,
}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      String searchResult = currentLecture;
      return StatefulBuilder(builder: (context, setState) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog.fullscreen(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop('');
                          },
                          icon: Icon(Icons.cancel)),
                      Header('Search Lecture'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('Save$searchResult');
                          },
                          child: Text('Save')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('Delete');
                          },
                          child: Text('Delete')),
                    ],
                  ),
                  Row(
                    children: [
                      Paragraph('Find lecture by name or professor'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          searchResult = await showSearch(
                            context: context,
                            delegate:
                                CustomSearchDelegate(cellText: currentCellNum),
                          );
                          setState(() {
                            searchResult = searchResult;
                          });
                        },
                        icon: const Icon(Icons.search),
                      )
                    ],
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        Flexible(
                            child: Text(searchResult.isEmpty
                                ? 'Your lecture: $currentLecture'
                                : 'Your lecture: $searchResult')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
