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

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _articleList = List();
  int pageNo = 0;
  int _status = Status.Loading;
  String _errorMsg;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    return HttpUtils.get(Apis.articles(pageNo)).then((result) {
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
              itemBuilder: buildItem,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 0,
                );
              },
            ),
            onRefresh: () {
              return getData();
            },
          ),
        )
      ],
    );
  }

  Widget getFresh(fresh) {
    if (fresh) {
      return Container(
          margin: EdgeInsets.only(left: 10),
          child: Text('新',
              style: TextStyle(
                color: Colors.redAccent,
              )));
    }
    return Container();
  }

  Widget getPic(String url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: 120,
        height: 90,
      );
    }
    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget geDesc(String desc) {
    if (desc != null && desc.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          desc,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );
    }
    return Container();
  }

  Widget buildItem(context, index) {
    var item = _articleList.elementAt(index);
    return InkWell(
      onTap: () {
        HintUtils.log('查看文章详情...');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  item['author'],
                ),
                getFresh(item['fresh']),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '置顶',
                  ),
                ),
                Expanded(
                  child: Text(
                    item['niceDate'],
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  getPic(item['envelopePic']),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item['title'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        geDesc(item['desc']),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item['superChapterName'] + '/' + item['chapterName'],
                  ),
                ),
                InkWell(
                  onTap: () {
                    HintUtils.log('收藏+1');
                  },
                  child: IconButton(
                    icon: Icon(Icons.star_border),
                    color: Colors.black54,
                    padding: EdgeInsets.all(2),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
