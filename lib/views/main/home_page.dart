import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/config/tag.dart';
import 'package:wanandroid_flutter/widget/home_banner.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshableList(
      [
        Apis.banner(),
        Apis.topArticles(),
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

  _buildItem(item, index) {
    if (item is List) {
      return HomeBanner(
        item,
        (item) {
          print("点击了 banner : ${item['title']}");
        },
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
