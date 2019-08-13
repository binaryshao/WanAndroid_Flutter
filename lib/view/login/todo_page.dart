import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';
import 'package:wanandroid_flutter/view/login/edit_todo_page.dart';
import 'package:wanandroid_flutter/config/event.dart';

class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务清单'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              NavUtil.navTo(context, EditTodoPage());
            },
          )
        ],
      ),
      body: RefreshableList(
        [Apis.todo],
        ['datas'],
        [''],
        _buildItem,
        listenTypes: [TodoDelete, Todo],
      ),
    );
  }

  _buildItem(item, index) {
    return InkWell(
      onTap: () {
        NavUtil.navTo(context, EditTodoPage(item: item));
      },
      child: Container(
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
                            ? Theme.of(context).primaryColor
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
                    width: 24,
                    child: IconButton(
                      icon: Icon((Icons.delete_forever)),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        HintUtil.alert(
                            context, '删除任务', '确定要删除任务【${item['title']}】吗？', () {
                          Apis.todoDelete(item['id']).then((result) {
                            HintUtil.toast(context, '已删除');
                            eventBus.fire(TodoDelete());
                          }).catchError((e) {
                            HintUtil.toast(context, e.toString());
                          }).whenComplete(() {
                            NavUtil.pop(context);
                          });
                        }, () {
                          NavUtil.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
