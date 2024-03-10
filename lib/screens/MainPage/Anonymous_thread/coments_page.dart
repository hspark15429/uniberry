import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;

  const CommentsPage({Key? key, required this.comments}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "댓글",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return ListTile(
                    title: Text(
                      comment.content,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      "작성일: ${comment.datePosted}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, size: 20, color: Colors.redAccent),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.comment, size: 20, color: Colors.redAccent),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildCommentInputField(),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCommentInputField(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "댓글을 입력하세요...",
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 14.0,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.orange),
            onPressed: () {
              _addComment(_commentController.text);
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _addComment(String content) {
    final newComment = Comment(
      content: content,
      datePosted: DateTime.now().toString(), id: null,
    );
    setState(() {
      _comments.add(newComment);
    });
  }
}
