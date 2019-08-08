import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/config/tag.dart';
import 'package:wanandroid_flutter/config/colors.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid_flutter/views/search_page_result.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            search(value);
          },
          decoration: InputDecoration(
            hintText: '请输入搜索内容...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              search(_controller.text);
            },
          )
        ],
      ),
      body: RefreshableList(
        [Apis.hotKeys()],
        [''],
        [Tags.hotKey],
        _buildItem,
        showFloating: false,
      ),
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

  search(String keyword) {
    if (keyword.isNotEmpty) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => SearchResultPage(
                    keyword,
                  )));
    } else {
      HintUtils.toast(context, '搜索内容不能为空...');
    }
  }
}
