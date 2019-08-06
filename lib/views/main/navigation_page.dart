import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/refreshable_list.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/config/status.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List<dynamic> data;
  int _selectedIndex = 0;
  Status _status = Status.Loading;
  String _errorMsg;

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
    }).catchError((e) {
      setState(() {
        _status = Status.Error;
        setError(e);
      });
    });
  }

  setError(e) {
    HintUtils.log('发生错误：$e');
    if (e is Exception) {
      _errorMsg = e.toString();
    } else if (e is String) {
      _errorMsg = e;
    }
    _errorMsg = e.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
      ],
    );
  }

  _buildRightItem(item) {}
}