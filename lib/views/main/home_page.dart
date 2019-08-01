import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'package:wanandroid_flutter/widget/end_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
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
  int _pageNo = 0;
  Status _status = Status.Loading;
  MoreStatus _moreStatus = MoreStatus.Init;
  String _errorMsg;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_moreStatus == MoreStatus.Init || _moreStatus == MoreStatus.Error) {
          loadMore();
        }
      }
    });
    getData();
  }

  Future getData({bool isLoadingMore = false}) async {
    if (!isLoadingMore) {
      _pageNo = 0;
    }
    HttpUtils.get(Apis.articles(_pageNo)).then((result) {
      setState(() {
        _moreStatus = (_pageNo + 1) >= result['pageCount']
            ? MoreStatus.End
            : MoreStatus.Init;
        _pageNo++;
        if (isLoadingMore) {
          _articleList.addAll(result['datas']);
        } else {
          _articleList = result['datas'];
        }
        if (_articleList.length == 0) {
          _status = Status.Empty;
        }
        _status = Status.Success;
      });
    }).catchError((error) {
      if (isLoadingMore) {
        _moreStatus = MoreStatus.Error;
      } else {
        _status = Status.Error;
      }
      _errorMsg = error;
    });
  }

  loadMore() {
    setState(() {
      _moreStatus = MoreStatus.Loading;
    });
    getData(isLoadingMore: true);
  }

  retry() {
    setState(() {
      _status = Status.Loading;
    });
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
            retry: retry,
          ),
        ),
        Offstage(
          offstage: _status != Status.Empty,
          child: EmptyView(
            retry: retry,
          ),
        ),
        Offstage(
          offstage: _status != Status.Success,
          child: RefreshIndicator(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _articleList.length + 1,
              itemBuilder: (context, index) {
                if (index == _articleList.length) {
                  switch (_moreStatus) {
                    case MoreStatus.Init:
                      return Container();
                      break;
                    case MoreStatus.Loading:
                      return LoadingView();
                      break;
                    case MoreStatus.Error:
                      return ErrorView(
                        error: _errorMsg,
                        retry: loadMore,
                      );
                      break;
                    case MoreStatus.End:
                      return EndView();
                      break;
                  }
                }
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
