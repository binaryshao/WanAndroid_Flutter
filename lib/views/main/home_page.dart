import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/config/tag.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshableList(
      [
        Apis.banner,
        Apis.topArticles,
        Apis.articles,
      ],
      [
        '',
        '',
        'datas',
      ],
      [
        HomeTag.banner,
        HomeTag.top,
        HomeTag.normal,
      ],
      _buildItem,
    );
  }

  _buildItem(item) {
    if (item is List) {
      return Container(
        padding: EdgeInsets.all(50),
        child: Text(
          'banner 待展示...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }
    switch (item['localTag']) {
      case HomeTag.top:
        item['isTop'] = true;
        return ArticleItemView(item);
      case HomeTag.normal:
        return ArticleItemView(item);
        break;
    }
  }
}
