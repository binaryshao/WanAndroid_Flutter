import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/config/status.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'dart:math';
import 'package:wanandroid_flutter/utils/common_utils.dart';
import 'package:wanandroid_flutter/config/colors.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List<dynamic> data;
  int _selectedIndex = 0;
  Status _status = Status.Loading;
  String _errorMsg;
  RefreshableList rightView;
  List rightItemHeights = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    Apis.navigation().then((result) {
      data = result;
      if (data.length == 0) {
        _status = Status.Empty;
      } else {
        _status = Status.Success;
      }
      setState(() {});
    }).catchError((e) {
      setState(() {
        _status = Status.Error;
        setError(e);
        setState(() {});
      });
    });
  }

  setError(e) {
    HintUtils.log('NavigationPage 发生错误：$e');
    if (e is Exception) {
      _errorMsg = e.toString();
    } else if (e is String) {
      _errorMsg = e;
    }
    _errorMsg = e.toString();
  }

  retry() {
    setState(() {
      _status = Status.Loading;
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case Status.Loading:
        return LoadingView();
        break;
      case Status.Error:
        return ErrorView(
          error: _errorMsg,
          retry: retry,
        );
        break;
      case Status.Empty:
        return EmptyView(
          retry: retry,
        );
        break;
      case Status.Success:
        if (rightView == null) {
          rightView = RefreshableList(
            [data],
            [''],
            [''],
            _buildRightItem,
            divider: (index) {
              return Container(
                height: 10,
              );
            },
            refreshable: false,
          );
        }
        return Row(
          children: <Widget>[
            Container(
              width: 100,
              child: RefreshableList(
                [data],
                [''],
                [''],
                _buildLeftItem,
                refreshable: false,
              ),
            ),
            Expanded(
              child: rightView,
            ),
          ],
        );
        break;
    }
  }

  getJumpHeight(index) {
    double result = 0.0;
    for (int i = 0; i < index; i++) {
      result += rightItemHeights[i];
    }
    return result;
  }

  _buildLeftItem(item, index) {
    return InkWell(
      onTap: () {
        _selectedIndex = index;
        rightView.jumpTo(getJumpHeight(index));
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            item['name'],
            style: TextStyle(
                color: index == _selectedIndex ? Colors.blue : Colors.black54),
          ),
        ),
      ),
    );
  }

  _buildRightItem(item, index) {
    /// 粗略估算item高度
    var factor = item['articles'].length > 8 ? 13 : 30;
    rightItemHeights.add(20 + item['articles'].length * factor);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item['name'],
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0x6FECEFF6),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: item['articles'].map<Widget>((value) {
                var color = tagColors[Random().nextInt(tagColors.length - 1)];
                return InkWell(
                  onTap: () {
                    CommonUtils.navToWeb(
                        context, value['link'], value['title']);
                  },
                  child: Text(
                    value['title'],
                    style: TextStyle(fontSize: 16, color: color),
                  ),
                );
              }).toList(),
              spacing: 15,
              runSpacing: 15,
            ),
          ),
        ],
      ),
    );
  }
}
