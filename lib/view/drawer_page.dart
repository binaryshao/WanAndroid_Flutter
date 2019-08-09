import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/image_util.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            color: Theme.of(context).primaryColor,
            height: 180,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageUtil.getRoundImage('ic_avatar', 40),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    '还没有登录...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              getItem('ic_favorite_not', '收藏夹', () {}),
              getItem('ic_todo', '任务清单', () {}),
              getItem('ic_about', '关于', () {}),
              getItem('ic_logout', '退出登录', () {}),
            ],
          ),
        ),
      ],
    );
  }

  getItem(imgName, title, onTap) {
    return ListTile(
      leading: Image.asset(
        ImageUtil.getImagePath(imgName),
        width: 20,
        height: 20,
        color: Colors.black54,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
