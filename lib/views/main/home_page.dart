import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/config/tag.dart';
import 'package:wanandroid_flutter/widget/home_banner.dart';
import 'package:wanandroid_flutter/utils/common_utils.dart';

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
      (item, index) {
        if (item is List) {
          return HomeBanner(
            item,
            (item) {
              CommonUtils.navToWeb(context, item['url'], item['title']);
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
      },
    );
  }
}
