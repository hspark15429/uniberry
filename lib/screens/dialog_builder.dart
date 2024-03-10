import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/search_page.dart';

Future<String?> timetableEntryDialogBuilder(
  BuildContext context, {
  required String currentLecture,
  required String currentCellNum,
}) async {
  String newLecture = "";
  return showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return WillPopScope(
          onWillPop: () async => false,
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
                    Text('講義検索'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop('Save$newLecture');
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
                    Text('講義名または教授名で検索'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        var searchResult = await showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                            cellText: currentCellNum,
                          ),
                        );
                        if (searchResult != null)
                          setState(() {
                            newLecture = searchResult;
                          });
                        else
                          setState(() {
                            newLecture = 'searchResult is null';
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
                        child: Text(newLecture.isEmpty
                            ? '講義名: $currentLecture'.split('@')[0]
                            : '講義名: $newLecture'.split('@')[0]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SafeArea(
                  child: Row(
                    children: [
                      Visibility(
                        visible: newLecture.isEmpty
                            ? currentLecture.split('@').length >= 2
                            : newLecture.split('@').length >= 2,
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 24, left: 24, bottom: 4),
                            child: ListTile(
                              leading:
                                  CircleAvatar(child: Icon(Icons.event_note)),
                              title: Text('Syllabus'),
                              onTap: () => openUrl(
                                newLecture.isEmpty
                                    ? '${currentLecture.split('@').length >= 2 ? currentLecture.split('@')[1] : ""}'
                                    : '${newLecture.split('@').length >= 2 ? newLecture.split('@')[1] : ""}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

openUrl(String s) {
}
