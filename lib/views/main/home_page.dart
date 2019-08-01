import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'package:wanandroid_flutter/widget/end_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';
import 'package:wanandroid_flutter/utils/common_utils.dart';
import 'package:wanandroid_flutter/utils/apis.dart';
import 'package:wanandroid_flutter/utils/http_utils.dart';
import 'package:wanandroid_flutter/config/status.dart';
import 'package:wanandroid_flutter/widget/article_item_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _articleList = List();
  int pageNo = 0;
  Status _status = Status.Loading;
  String _errorMsg;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    HttpUtils.get(Apis.articles(pageNo)).then((result) {
      setState(() {
        _articleList = result['datas'];
        if (_articleList.length == 0) {
          _status = Status.Empty;
        }
        _status = Status.Success;
      });
    }).catchError((error) {
      _status = Status.Error;
      _errorMsg = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _status != Status.Loading,
          child: LoadingView(),
        ),
        Offstage(
          offstage: _status != Status.Error,
          child: ErrorView(
            error: _errorMsg,
          ),
        ),
        Offstage(
          offstage: _status != Status.Empty,
          child: EmptyView(),
        ),
        Offstage(
          offstage: _status != Status.Success,
          child: RefreshIndicator(
            child: ListView.separated(
              itemCount: _articleList.length,
              itemBuilder: (context, index) {
                return ArticleItemView(_articleList.elementAt(index));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 0,
                );
              },
            ),
            onRefresh: getData,
          ),
        )
      ],
    );
  }
}
