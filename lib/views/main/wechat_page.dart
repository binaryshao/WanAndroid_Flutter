import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/article_tab_page.dart';
import 'package:wanandroid_flutter/utils/apis.dart';

class WechatPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ArticleTabPage(Apis.wxChapters(), null);
  }
}
