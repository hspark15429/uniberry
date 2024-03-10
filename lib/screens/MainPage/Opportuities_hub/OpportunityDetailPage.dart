import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/MainPage/Opportuities_hub/dummy_opportunities.dart'; // 가정: 기회 모델 정의 파일

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailPage({Key? key, required this.opportunity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(opportunity.title), // 기회의 제목
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                opportunity.category,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                opportunity.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(opportunity.description), // 기회의 상세 설명
            ),
            // 이미지가 있는 경우 슬라이더로 표시
            if (opportunity.imageUrls.isNotEmpty)
              Container(
                height: 250,
                child: PageView.builder(
                  itemCount: opportunity.imageUrls.length,
                  itemBuilder: (context, index) => Image.network(opportunity.imageUrls[index], fit: BoxFit.cover),
                ),
              ),
            // 추가 정보 및 연락처 등이 표시될 수 있는 부분
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "추가 정보:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(opportunity.additionalInfo ?? "없음"), // 추가 정보 (옵션)
            ),
          ],
        ),
      ),
    );
  }
}
