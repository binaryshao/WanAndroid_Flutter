import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/config/tag.dart';
import 'package:wanandroid_flutter/config/colors.dart';
import 'dart:math';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              search(keyword);
            },
          )
        ],
      ),
      body: RefreshableList([Apis.hotKeys()], [''], [Tags.hotKey], _buildItem),
    );
  }

  _buildItem(item, index) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '大家都在搜',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: item.map<Widget>((value) {
                var color = tagColors[Random().nextInt(tagColors.length - 1)];
                return InkWell(
                  onTap: () {
                    search(value['name']);
                  },
                  child: Text(
                    value['name'],
                    style: TextStyle(fontSize: 16, color: color),
                  ),
                );
              }).toList(),
              spacing: 20,
              runSpacing: 20,
            ),
          ),
        ],
      ),
    );
  }

  search(keyword) {
  }
}
