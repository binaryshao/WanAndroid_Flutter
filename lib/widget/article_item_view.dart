import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/config/event.dart';
import 'package:wanandroid_flutter/util/account_util.dart';
import 'package:wanandroid_flutter/view/login/login_page.dart';
import 'package:wanandroid_flutter/util/apis.dart';

class ArticleItemView extends StatefulWidget {
  final item;

  final isFromFavorite;

  ArticleItemView(this.item, {this.isFromFavorite = false});

  @override
  State<StatefulWidget> createState() {
    return _ArticleItemViewState();
  }
}

class _ArticleItemViewState extends State<ArticleItemView> {
  StreamSubscription logoutSubscription;

  @override
  void initState() {
    super.initState();
    logoutSubscription = eventBus.on<Logout>().listen((event) {
      setState(() {
        widget.item['collect'] = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    logoutSubscription.cancel();
  }

  Widget getFresh(isOk, text, color) {
    if (isOk) {
      return Container(
          margin: EdgeInsets.only(left: 10),
          child: Text('$text',
              style: TextStyle(
                color: color,
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
        fit: BoxFit.cover,
      );
    }
    return Container();
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavUtil.navToWeb(context, widget.item['link'], widget.item['title']);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  widget.item['author'],
                ),
                getFresh(
                    widget.item['fresh'] != null ? widget.item['fresh'] : false,
                    "新",
                    Colors.redAccent),
                getFresh(
                    widget.item['isTop'] != null ? widget.item['isTop'] : false,
                    "置顶",
                    Colors.deepPurple),
                Expanded(
                  child: Text(
                    widget.item['niceDate'],
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  getPic(widget.item['envelopePic']),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: widget.item['envelopePic'].isNotEmpty ? 10 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.item['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          geDesc(widget.item['desc']),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${widget.item['superChapterName']}/${widget.item['chapterName']}",
                  ),
                ),
                Container(
                  height: 24,
                  child: IconButton(
                    icon:
                        widget.item['collect'] != null && widget.item['collect']
                            ? Icon(
                                Icons.star,
                                color: Colors.redAccent,
                              )
                            : Icon(Icons.star_border),
                    color: Colors.black54,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      switchFavorite();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  switchFavorite() async {
    String name = await AccountUtil.getUserName();
    if (name == null || name.isEmpty) {
      NavUtil.navTo(context, LoginPage());
      HintUtil.toast(context, '请先登录');
    } else {
      Future future = widget.item['collect']
          ? widget.isFromFavorite
              ? Apis.uncollectFromFavorite(
                  widget.item['id'],
                  widget.item['originId'] != null
                      ? widget.item['originId'].toString()
                      : '-1')
              : Apis.uncollect(widget.item['id'])
          : Apis.collect(widget.item['id']);
      future.then((result) {
        HintUtil.toast(context, widget.item['collect'] ? "已取消收藏" : "收藏成功");
        if (widget.isFromFavorite) {
          eventBus.fire(SwitchFavorite());
        } else {
          setState(() {
            widget.item['collect'] = !widget.item['collect'];
          });
        }
      }).catchError((e) {});
    }
  }
}
