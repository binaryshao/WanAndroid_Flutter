import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: RefreshableList([Apis.favorite], ['datas'], [''], (item, index) {
        item['collect'] = true;
        return ArticleItemView(
          item,
          isFromFavorite: true,
        );
      }),
    );
  }
}
