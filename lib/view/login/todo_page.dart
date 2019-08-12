import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';

class TodoPage extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('任务清单'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              HintUtil.toast(context, 'to be completed...');
            },
          )
        ],
      ),
      body: RefreshableList([Apis.todo], ['datas'], [''], _buildItem),
    );
  }

  _buildItem(item, index) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  item['title'],
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              Text(item['dateStr']),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  item['status'] == 0 ? "未完成" : "已完成",
                  style: TextStyle(
                      color: item['status'] == 0
                          ? Theme.of(_context).primaryColor
                          : Colors.grey),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item['content'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  child: IconButton(
                    icon: Icon((Icons.delete_forever)),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      HintUtil.toast(_context, 'to be deleteed...');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
