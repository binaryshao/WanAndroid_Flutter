import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/article_tab_page.dart';
import 'package:wanandroid_flutter/util/apis.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArticleTabPage(Apis.projectChapters(), null);
  }
}
