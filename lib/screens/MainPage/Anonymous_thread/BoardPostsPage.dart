// BoardPostsPage.dart
import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/post_detail.dart';

class BoardPostsPage extends StatelessWidget {
  final String boardName;
  const BoardPostsPage({Key? key, required this.boardName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> boardPosts = dummyPosts.where((post) => post.category == boardName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$boardName 게시판'),
      ),
      body: ListView.builder(
        itemCount: boardPosts.length,
        itemBuilder: (context, index) {
          final post = boardPosts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
              );
            },
          );
        },
      ),
    );
  }
}
