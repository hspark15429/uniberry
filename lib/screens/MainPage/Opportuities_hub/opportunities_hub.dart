import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Opportuities_hub/dummy_opportunities.dart';

// Opportunities Hub 페이지 정의
class OpportunitiesHubPage extends StatefulWidget {
  const OpportunitiesHubPage({Key? key}) : super(key: key);

  @override
  _OpportunitiesHubPageState createState() => _OpportunitiesHubPageState();
}

class _OpportunitiesHubPageState extends State<OpportunitiesHubPage> {
  @override
  Widget build(BuildContext context) {
    // Opportunities Hub 페이지 레이아웃 및 로직 구현
    return Scaffold(
      appBar: AppBar(
        title: Text('Opportunities Hub'),
      ),
      body: ListView.builder(
        itemCount: dummyOpportunities.length, // 더미 데이터로부터 항목 개수 가져오기
        itemBuilder: (context, index) {
          final opportunity = dummyOpportunities[index];
          return Card(
            child: ListTile(
              title: Text(opportunity.title),
              subtitle: Text(opportunity.description),
              onTap: () {
                // 상세 페이지 또는 외부 링크로 이동 로직 구현
              },
            ),
          );
        },
      ),
    );
  }
}
