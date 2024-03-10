import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/post_detail.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/thread_write_page.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "접기" : "더 보기",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

class AnonymousThreadPage extends StatefulWidget {
  final String currentBoard;

  const AnonymousThreadPage({Key? key, required this.currentBoard}) : super(key: key);

  @override
  _AnonymousThreadPageState createState() => _AnonymousThreadPageState();
}

class _AnonymousThreadPageState extends State<AnonymousThreadPage> {
  @override
  Widget build(BuildContext context) {
    // 생성자에서 전달받은 currentBoard를 사용하여 게시물을 필터링
    List<Post> filteredPosts = dummyPosts.where((post) => post.boardType.toString().split('.').last == widget.currentBoard).toList();

    return Scaffold(
      appBar: AppBar(
        // AppBar의 제목도 생성자에서 전달받은 currentBoard 값을 사용
        title: Text('#${boardTypeToString(BoardType.values.firstWhere((type) => type.toString().split('.').last == widget.currentBoard))}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: 게시판 검색 페이지로 이동
            },
          ),
          IconButton(
  icon: Icon(Icons.create), // 게시글 작성 아이콘
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThreadWritePage()),
    );
  },
),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("#${post.category}", style: TextStyle(color: Color.fromARGB(255, 245, 86, 0), fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(post.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Text("댓글 ${post.commentCount}개", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Text("작성일 ${post.datePosted} · 조회수 ${post.viewCount}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 8),
                    ExpandableText(text: post.content, maxLines: 3),
                    if (post.imageUrls.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        child: Image.network(post.imageUrls.first, fit: BoxFit.cover),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
