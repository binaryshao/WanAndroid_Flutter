import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';

class SearchResultPage extends StatelessWidget {
  final String keyword;

  SearchResultPage(this.keyword);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(keyword),
      ),
      body: RefreshableList([Apis.search(keyword)], ['datas'], [''],
          (item, index) {
        return ArticleItemView(item);
      }),
    );
  }
}
