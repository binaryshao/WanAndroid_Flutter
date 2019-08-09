import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/article_tab_page.dart';

class KnowledgePage extends StatelessWidget {
  String title;
  List<dynamic> data;

  KnowledgePage(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ArticleTabPage(null, data),
    );
  }
}
