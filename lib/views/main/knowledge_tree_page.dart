import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid_flutter/views/knowledge_page.dart';

const colors = [
  Colors.orange,
  Colors.green,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.pink,
  Colors.blue,
];

class KnowledgeTreePage extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return RefreshableList(
      [Apis.knowledgeTree()],
      [''],
      [''],
      _buildItem,
      divider: (index) {
        return Container(
          height: 20,
        );
      },
    );
  }

  _buildItem(item) {
    return InkWell(
      onTap: () {
        Navigator.of(_context).push(CupertinoPageRoute(
            builder: (context) => KnowledgePage(
                  item['name'],
                  item['children'],
                )));
      },
      child: Container(
        color: Color(0x6FECEFF6),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item['name'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Wrap(
                children: item['children'].map<Widget>((value) {
                  var color = colors[Random().nextInt(colors.length - 1)];
                  return Text(
                    value['name'],
                    style: TextStyle(fontSize: 16, color: color),
                  );
                }).toList(),
                spacing: 10,
                runSpacing: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
