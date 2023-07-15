import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/widgets.dart';

Future<String?> dialogBuilder(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
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
                        Navigator.of(context).pop('Enable');
                      },
                      child: Text('Save')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('Disable');
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
                      final result = await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              Row(
                children: [
                  Paragraph('Your lecture: '),
                ],
              ),
            ],
          ),
        ),

        // AlertDialog(
        //   title: const Text('Basic dialog title'),
        //   content: const Text(
        //     'A dialog is a type of modal window that\n'
        //     'appears in front of app content to\n'
        //     'provide critical information, or prompt\n'
        //     'for a decision to be made.',
        //   ),
        //   actions: <Widget>[
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Disable'),
        //       onPressed: () {
        //         Navigator.of(context).pop('Disable');
        //       },
        //     ),
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Enable'),
        //       onPressed: () {
        //         Navigator.of(context).pop('Enable');
        //       },
        //     ),
        //   ],
        // ),
      );
    },
  );
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    // fruits
    'Apple',
    'Banana',
    'Cherry',
    'Durian',
    'Fig',
    'Grape',
  ];
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
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
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
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
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
