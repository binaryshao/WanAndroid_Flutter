import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshableList(
      [
        Apis.articles,
      ],
      [
        'datas',
      ],
      [
        '',
      ],
      _buildItem,
    );
  }

  _buildItem(item) {
    return ArticleItemView(item);
  }
}
