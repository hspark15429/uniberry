import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/coments_page.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // 공유 기능 구현
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // 스크랩 기능 구현
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Padding(
  padding: const EdgeInsets.all(8.0),
  child: 
  Text("#${post.category}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)), // 여기에 색상 추가
),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.content),
            ),
            if (post.imageUrls.isNotEmpty)
              Container(
                height: 200,
                child: PageView.builder(
                  itemCount: post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageViewerPage(imageUrls: post.imageUrls, initialIndex: index),
                        ),
                      ),
                      child: Image.network(post.imageUrls[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.redAccent),
                    onPressed: () {
                      // 좋아요 기능 구현
                    },
                  ),
                  Text("${post.likesCount}"),
                  IconButton(
                    icon: Icon(Icons.comment, size: 20, color: Colors.redAccent),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CommentsPage(comments: post.comments),
                      );
                    },
                  ),
                  Text("${post.commentCount}"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ...post.comments.map((comment) => ListTile(
                  title: Text(comment.content),
                  subtitle: Text("작성일: ${comment.datePosted}", style: TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.redAccent),
                        onPressed: () {
                          // 댓글에 대한 좋아요 기능 구현
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.comment, size: 20, color: Colors.redAccent),
                        onPressed: () {
                          // 답글 기능 구현
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}



class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPage({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentIndex + 1}/${widget.imageUrls.length}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.imageUrls.length,
        controller: PageController(initialPage: currentIndex),
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Hero(
            tag: 'imageHero',
            child: Image.network(widget.imageUrls[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}