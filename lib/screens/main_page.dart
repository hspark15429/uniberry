import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/anonymous_thread.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:gtk_flutter/screens/MainPage/Anonymous_thread/post_detail.dart';
import 'package:gtk_flutter/screens/MainPage/Opportuities_hub/dummy_opportunities.dart';
import 'package:gtk_flutter/screens/settiing/notificationPage.dart';
import 'package:gtk_flutter/screens/settiing/scrapPage.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MainPage/todolist_page.dart';
import 'settiing/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isBoardListExpanded = false; // 게시판 목록의 펼침 상태를 관리



  Future<void> openUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await canLaunch(_url.toString())) {
      throw 'Could not launch $url';
    } else {
      await launch(_url.toString());
    }
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String url}) {
    return GestureDetector(
      onTap: () => openUrl(url),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14)),
          Text(subtitle, style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String subtitle,
      required List<Widget> buttons}) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons),
        ],
      ),
    );
  }

   Widget _buildBoardListCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '게시판 목록',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isBoardListExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() {
                          isBoardListExpanded = !isBoardListExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // TODO: 검색 기능을 여기에 구현
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: isBoardListExpanded,
            child: Column(
              children: [
                _buildBoardSections(context),
                // 필요한 경우 여기에 더 많은 위젯 추가
              ],
            ),
          ),
        ],
      ),
    );
  }

 // 전체 게시판을 표시하는 카드
Widget _buildAllBoardsCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 주목중인 게시판', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildAllPosts(context),
          ],
        ),
      ),
    );
  }

// 게시판 목록을 보여주는 섹션을 구현하는 메서드
Widget _buildBoardSections(BuildContext context) {
  return ListView(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: BoardType.values.map((boardType) {
      return ListTile(
        title: Text(boardTypeToString(boardType)),
        onTap: () {
          // 여기서 AnonymousThreadPage로 네비게이션하면서 선택된 boardType 전달
         Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AnonymousThreadPage(currentBoard: boardType.toString().split('.').last)),
);
        },
      );
    }).toList(),
  );
}


Widget _buildAllPosts(BuildContext context) {
  List<Post> sortedPosts = List.from(dummyPosts)
    ..sort((a, b) {
      int compare = b.viewCount.compareTo(a.viewCount);
      if (compare == 0) {
        return b.commentCount.compareTo(a.commentCount);
      }
      return compare;
    });

  List<Post> topPosts = sortedPosts.take(4).toList();

  return ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: topPosts.length,
    separatorBuilder: (context, index) => Divider(color: Colors.grey),
    itemBuilder: (context, index) {
      final post = topPosts[index];
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(post: post),
              // `post` 객체를 `PostDetailPage` 생성자에 전달합니다.
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "#${post.category}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${post.commentCount}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "コメント",
                          style: TextStyle(fontSize: 10,
                           color: Colors.redAccent,
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "作成日 ${post.datePosted} · 閲覧数 ${post.viewCount}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildOpportunitiesBox(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.8);
    int _currentPage = 0;

    return Column(
      children: [
        Container(
          height: 200,
          margin: EdgeInsets.symmetric(vertical: 10), // 조정된 간격
          child: PageView.builder(
            itemCount: dummyOpportunities.length,
            controller: pageController,
            onPageChanged: (index) {
              _currentPage = index;
            },
            itemBuilder: (context, index) {
              final opportunity = dummyOpportunities[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(opportunity.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(opportunity.description),
                        onTap: () {
                          // Add logic for navigating to detailed page here
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20), // 조정된 간격
        PageViewDotIndicator(
          currentItem: _currentPage,
          count: dummyOpportunities.length,
          unselectedColor: Colors.grey,
          selectedColor: Colors.blue,
          size: const Size(8, 8),
        ),
        SizedBox(height: 20), // 조정된 간격
      ],
    );
  }

  Widget _buildAdditionalBox(BuildContext context, {required String title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Home'),
  leading: IconButton(
    icon: Icon(Icons.notifications),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationPage()),
      );
    },
  ),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.bookmark),
      onPressed: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScrapPage()),
        );
      },
    ),
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      },
    ),
  ],
),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTile(
                      context,
                      icon: Icons.mode_edit,
                      title: 'Manaba+R',
                      subtitle: '',
                      url: 'https://ct.ritsumei.ac.jp/ct/',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.event_note,
                      title: '学年暦',
                      subtitle: '',
                      url: 'https://www.ritsumei.ac.jp/profile/info/calendar/',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.insert_invitation,
                      title: '授業スケジュール',
                      subtitle: '',
                      url: 'https://www.ritsumei.ac.jp/file.jsp?id=562469',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.library_books,
                      title: '図書館',
                      subtitle: '',
                      url: 'https://runners.ritsumei.ac.jp/opac/opac_search/?lang=0',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.web,
                      title: '大学ホームページ',
                      subtitle: '',
                      url: 'https://en.ritsumei.ac.jp/',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.bus_alert_rounded,
                      title: 'シャトルバス',
                      subtitle: '',
                      url: 'https://www.ritsumei.ac.jp/file.jsp?id=566535',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // 조정된 간격
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildInfoCard(
                      context,
                      title: '今日の予定',
                      subtitle: '2月 22日(木)',
                      buttons: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TodolistPage(openAddDialog: true),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TodolistPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 20), // 조정된 간격
                    _buildInfoCard(
                        context,
                        title: '新学期を始めよう!',
                        subtitle: '学割、募集中の部活など',
                        buttons: [TextButton(onPressed: () {}, child: Text('詳しく見る', style: TextStyle(decoration: TextDecoration.underline)))]
                    ),
                    SizedBox(width: 20), // 조정된 간격
                    _buildInfoCard(
                        context,
                        title: '時間割をDIYしよう',
                        subtitle: '講義選びのコツや効率的な時間割作成方法など',
                        buttons: [TextButton(onPressed: () {}, child: Text('詳しく見る', style: TextStyle(decoration: TextDecoration.underline)))]
                    ),
                    SizedBox(width: 20), // 조정된 간격
                    _buildInfoCard(
                        context,
                        title: '卒業生後もユニベリと一緒に',
                        subtitle: '卒業生アカウントに転換する',
                        buttons: [TextButton(onPressed: () {}, child: Text('詳しく見る', style: TextStyle(decoration: TextDecoration.underline)))]
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // 위젯 간격 조정
          _buildAllBoardsCard(context),
             SizedBox(height: 10),
              // 기타 위젯들을 여기에 포함시킬 수 있습니다.
          _buildBoardListCard(context),
            SizedBox(height: 20), // 위젯 간격 조정
              _buildOpportunitiesBox(context),
              SizedBox(height: 20), // 조정된 간격
              _buildAdditionalBox(context, title: '중고거래 박스'),
            ],
          ),
        ),
      ),
    );
  }
}

