import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'package:wanandroid_flutter/widget/end_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
import 'package:wanandroid_flutter/config/status.dart';
import 'package:wanandroid_flutter/config/tag.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';
import 'package:wanandroid_flutter/config/event.dart';

/// 支持请求多个接口
/// 只有一个接口能分页，默认为 [_requests] 中最后一个接口
/// 该分页接口下标保存在 [pageNoUserIndex]，不可配置
/// 刷新时，请求所有接口
/// 上拉加载更多时，只请求分页接口
/// 除了 [banner], 其余配置都是业务无关
class RefreshableList extends StatefulWidget {
  /// 支持传入多个网络请求 [Future]
  /// 如果最后是分页接口，请传入 [Function]，因为页码在本控件内部维护
  /// 也可以直接传入数据列表
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

  /// 是否可以下拉刷新
  final refreshable;

  /// 分隔线
  final Function divider;

  /// 是否显示 FloatingActionButton
  final bool showFloating;

  final List<Type> listenTypes;

  RefreshableList(
    this._requests,
    this.dataKeys,
    this.tags,
    this._buildItem, {
    this.initPageNo = 0,
    this.pageCountKey = 'pageCount',
    this.refreshable = true,
    this.divider,
    this.showFloating = true,
    this.listenTypes,
  });

  _RefreshableListState _state = _RefreshableListState();

  @override
  State<StatefulWidget> createState() {
    return _state;
  }

  void jumpTo(double value) {
    _state.jumpTo(value);
  }

  animateTo(double offset, Duration duration, Curve curve) {
    _state.animateTo(offset, duration, curve);
  }
}

class _RefreshableListState extends State<RefreshableList>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> _dataList = List();
  int _pageNo;
  Status _status = Status.Loading;
  MoreStatus _moreStatus = MoreStatus.Init;
  String _errorMsg;
  ScrollController _scrollController = ScrollController();

  /// 分页接口的下标, 默认为 [_requests] 中最后一个接口
  var pageNoUserIndex;
  bool isMoreEnabled = true;
  bool scrollUP = false;
  double lastPixels = 0;
  StreamSubscription subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.listenTypes != null && widget.listenTypes.length > 0) {
      subscription = eventBus.on().listen((event) {
        for (int i = 0; i < widget.listenTypes.length; i++) {
          /// type.toString() 示例：TodoDelete
          /// event.toString() 示例：Instance of 'Todo'
          var type = widget.listenTypes.elementAt(i);
          int index = event.toString().indexOf("'");
          int lastIndex = event.toString().lastIndexOf("'");
          String eventType = event.toString().substring(index + 1, lastIndex);
          if (eventType.compareTo(type.toString()) == 0) {
            getData();
            break;
          }
        }
      });
    }
    pageNoUserIndex = widget._requests.length - 1;
    isMoreEnabled = widget._requests[pageNoUserIndex] is Function;
    if (isMoreEnabled) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_moreStatus == MoreStatus.Init ||
              _moreStatus == MoreStatus.Error) {
            loadMore();
          }
        }
      });
    }
    if (widget.showFloating) {
      _scrollController.addListener(() {
        bool scrollUPNow = _scrollController.position.pixels - lastPixels < 0;
        lastPixels = _scrollController.position.pixels;
        if (scrollUP != scrollUPNow) {
          setState(() {
            scrollUP = scrollUPNow;
          });
        }
      });
    }
    if (widget._requests[0] is List) {
      _dataList = widget._requests[0];
      _status = _dataList.length == 0 ? Status.Empty : Status.Success;
    } else {
      getData();
    }
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
      if (tag == Tags.banner || tag == Tags.hotKey) {
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
        setData(
            isMoreEnabled ? results[pageNoUserIndex][widget.pageCountKey] : 0,
            setResultTags(results),
            false);
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
      var pageNow = widget.initPageNo == 0 ? _pageNo + 1 : _pageNo;
      _moreStatus = pageNow >= pageCount ? MoreStatus.End : MoreStatus.Init;
      _pageNo++;
      if (isLoadMore) {
        _dataList.addAll(results);
      } else {
        _dataList = results;
      }
      if (_dataList.length == 0) {
        _status = Status.Empty;
      } else {
        _status = Status.Success;
      }
    });
  }

  setError(e) {
    HintUtil.log('RefreshableList 发生错误：$e');
    if (e is Exception) {
      _errorMsg = e.toString();
    } else if (e is String) {
      _errorMsg = e;
    }
    _errorMsg = e.toString();
  }

  loadMore() {
    setState(() {
      _moreStatus = MoreStatus.Loading;
    });
    getData(isLoadingMore: true);
  }

  retry() {
    if (!(widget._requests[0] is List)) {
      setState(() {
        _status = Status.Loading;
      });
      getData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
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
          child: Scaffold(
            body: selectList(),
            floatingActionButton: (widget.showFloating && scrollUP)
                ? FloatingActionButton(
                    onPressed: () {
                      jumpTo(0);
                      setState(() {
                        scrollUP = false;
                      });
                    },
                    tooltip: '回到顶部',
                    child: Icon(Icons.arrow_upward),
                  )
                : null,
          ),
        )
      ],
    );
  }

  selectList() {
    if (widget.refreshable) {
      return RefreshIndicator(
        child: getList(),
        onRefresh: getData,
      );
    }
    return getList();
  }

  getList() {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: _dataList.length + (isMoreEnabled ? 1 : 0),
      itemBuilder: (context, index) {
        if (isMoreEnabled && index == _dataList.length) {
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
        return widget._buildItem(_dataList.elementAt(index), index);
      },
      separatorBuilder: (BuildContext context, int index) {
        if (widget.divider != null) {
          return widget.divider(index);
        }
        return Divider(
          height: 0,
        );
      },
    );
  }

  animateTo(double offset, Duration duration, Curve curve) {
    _scrollController.animateTo(offset, duration: duration, curve: curve);
  }

  void jumpTo(double value) {
    _scrollController.jumpTo(value);
  }
}
