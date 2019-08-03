import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'package:wanandroid_flutter/widget/end_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
import 'package:wanandroid_flutter/config/status.dart';
import 'package:wanandroid_flutter/config/tag.dart';

/// 支持请求多个接口
/// 只有一个接口能分页，默认为 [_requests] 中最后一个接口
/// 该分页接口下标保存在 [pageNoUserIndex]，不可配置
/// 刷新时，请求所有接口
/// 上拉加载更多时，只请求分页接口
/// 除了 [banner], 其余配置都是业务无关
class RefreshableList extends StatefulWidget {
  /// 支持传入多个网络请求 [Future]
  /// 如果最后是分页接口，请传入 [Function]，因为页码在本控件内部维护
  final List<dynamic> _requests;

  /// 每个接口数据中的列表的 key，根据 key 获取每个接口返回的列表
  final List<String> dataKeys;

  /// 每个接口数据中的tag，方便调用方区分，以实现不同业务
  final List<dynamic> tags;

  /// item 的构建方法，业务方根据 item 中的 [localTag] 判断不同 item
  final Function _buildItem;

  /// 分页接口的初始页码
  final int initPageNo;

  /// 用于判断分页接口是否还有数据的 key
  final pageCountKey;

  RefreshableList(
    this._requests,
    this.dataKeys,
    this.tags,
    this._buildItem, {
    this.initPageNo = 0,
    this.pageCountKey = 'pageCount',
  });

  @override
  State<StatefulWidget> createState() {
    return _RefreshableListState();
  }
}

class _RefreshableListState extends State<RefreshableList> {
  List<dynamic> _dataList = List();
  int _pageNo;
  Status _status = Status.Loading;
  MoreStatus _moreStatus = MoreStatus.Init;
  String _errorMsg;
  ScrollController _scrollController = ScrollController();

  /// 分页接口的下标, 默认为 [_requests] 中最后一个接口
  var pageNoUserIndex;

  @override
  void initState() {
    super.initState();
    pageNoUserIndex = widget._requests.length - 1;
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

  getAllFutures() {
    var _futures = List<Future<dynamic>>();
    for (int i = 0; i < widget._requests.length; i++) {
      var request = pageNoUserIndex == i
          ? widget._requests[i] is Function
              ? widget._requests[i](_pageNo)
              : widget._requests[i]
          : widget._requests[i];
      _futures.add(request);
    }
    return _futures;
  }

  setResultTags(results) {
    var r = List();
    for (int i = 0; i < results.length; i++) {
      var dataKey = widget.dataKeys[i];
      var subList = dataKey.isEmpty ? results[i] : results[i][dataKey];
      var tag = widget.tags[i];
      if (tag == HomeTag.banner) {
        r.add(subList);
        continue;
      }
      for (var value in subList) {
        value['localTag'] = tag;
        r.add(value);
      }
    }
    return r;
  }

  setMoreResultTag(result) {
    var r = List();
    var dataKey = widget.dataKeys[pageNoUserIndex];
    var list = dataKey.isEmpty ? result : result[dataKey];
    for (var value in list) {
      value['localTag'] = widget.tags[pageNoUserIndex];
      r.add(value);
    }
    return r;
  }

  Future getData({bool isLoadingMore = false}) async {
    if (!isLoadingMore) {
      _pageNo = widget.initPageNo;
      Future.wait(getAllFutures()).then((results) {
        setData(results[pageNoUserIndex][widget.pageCountKey],
            setResultTags(results), false);
      }).catchError((e) {
        setState(() {
          _status = Status.Error;
          setError(e);
        });
      });
    } else {
      widget._requests[pageNoUserIndex](_pageNo).then((result) {
        setData(result[widget.pageCountKey], setMoreResultTag(result), true);
      }).catchError((e) {
        setState(() {
          _moreStatus = MoreStatus.Error;
          setError(e);
        });
      });
    }
  }

  setData(pageCount, results, isLoadMore) {
    setState(() {
      _moreStatus =
          (_pageNo + 1) >= pageCount ? MoreStatus.End : MoreStatus.Init;
      _pageNo++;
      if (isLoadMore) {
        _dataList.addAll(results);
      } else {
        _dataList = results;
      }
      if (_dataList.length == 0) {
        _status = Status.Empty;
      }
      _status = Status.Success;
    });
  }

  setError(e) {
    if (e is Exception) {
      _errorMsg = e.toString();
    } else if (e is String) {
      _errorMsg = e;
    }
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
              itemCount: _dataList.length + 1,
              itemBuilder: (context, index) {
                if (index == _dataList.length) {
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
                return widget._buildItem(_dataList.elementAt(index));
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
