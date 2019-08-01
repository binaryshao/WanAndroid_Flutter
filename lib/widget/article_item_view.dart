import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';

class ArticleItemView extends StatefulWidget {
  final item;

  ArticleItemView(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ArticleItemViewState();
  }
}

class _ArticleItemViewState extends State<ArticleItemView> {
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

  @override
  Widget build(BuildContext context) {
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
                  widget.item['author'],
                ),
                getFresh(widget.item['fresh']),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '置顶',
                  ),
                ),
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
                            fontSize: 18,
                          ),
                        ),
                        geDesc(widget.item['desc']),
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
                    "${widget.item['superChapterName']}/${widget.item['chapterName']}",
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
    ;
  }
}
