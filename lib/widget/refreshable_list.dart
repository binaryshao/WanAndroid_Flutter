import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/widget/empty_view.dart';
import 'package:wanandroid_flutter/widget/end_view.dart';
import 'package:wanandroid_flutter/widget/error_view.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';
import 'package:wanandroid_flutter/utils/http_utils.dart';
import 'package:wanandroid_flutter/config/status.dart';

class RefreshableList extends StatefulWidget {
  final Function _requestPath;
  final Function _buildItem;
  final int initPageNo;
  final pageCountIndex;
  final dataIndex;

  RefreshableList(
    this._requestPath,
    this._buildItem, {
    this.initPageNo = 0,
    this.pageCountIndex = 'pageCount',
    this.dataIndex = 'datas',
  });

  @override
  State<StatefulWidget> createState() {
    return _RefreshableListState();
  }
}

class _RefreshableListState extends State<RefreshableList> {
  List _dataList = List();
  int _pageNo;
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
      _pageNo = widget.initPageNo;
    }
    HttpUtils.get(widget._requestPath(_pageNo)).then((result) {
      setState(() {
        _moreStatus = (_pageNo + 1) >= result[widget.pageCountIndex]
            ? MoreStatus.End
            : MoreStatus.Init;
        _pageNo++;
        if (isLoadingMore) {
          _dataList.addAll(result[widget.dataIndex]);
        } else {
          _dataList = result[widget.dataIndex];
        }
        if (_dataList.length == 0) {
          _status = Status.Empty;
        }
        _status = Status.Success;
      });
    }).catchError((e) {
      setState(() {
        if (isLoadingMore) {
          _moreStatus = MoreStatus.Error;
        } else {
          _status = Status.Error;
        }
        if (e is Exception) {
          _errorMsg = e.toString();
        } else if (e is String) {
          _errorMsg = e;
        }
      });
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
    ;
  }
}
