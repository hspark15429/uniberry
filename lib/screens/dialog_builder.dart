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
                      Header('講義検索'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('Save$searchResult');
                          },
                          child: Text('保存')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('Delete');
                          },
                          child: Text('削除')),
                    ],
                  ),
                  Row(
                    children: [
                      Paragraph('講義名または教授名で検索'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          searchResult = await showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                              cellText: currentCellNum,
                            ),
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
                                ? '講義名: $currentLecture'
                                : '講義名: $searchResult')),
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
