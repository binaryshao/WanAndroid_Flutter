import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/image_util.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/view/login/favorite_page.dart';
import 'package:wanandroid_flutter/view/login/login_page.dart';
import 'package:wanandroid_flutter/util/account_util.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    refreshUser();
  }

  refreshUser() {
    AccountUtil.getUserName().then((name) {
      if (name != null) {
        setState(() {
          _userName = name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (_userName.isEmpty) {
              NavUtil.navTo(context, LoginPage());
            } else {
              HintUtil.toast(context, '你好...$_userName');
            }
          },
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
                    _userName.isEmpty ? '还没有登录...' : _userName,
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
              getItem('ic_favorite_not', '收藏夹', () {
                if (_userName.isEmpty) {
                  HintUtil.toast(context, '请先登录');
                  NavUtil.navTo(context, LoginPage());
                } else {
                  NavUtil.navTo(context, FavoritePage());
                }
              }),
              getItem('ic_todo', '任务清单', () {}),
              getItem('ic_about', '关于', () {}),
              getLogout(),
            ],
          ),
        ),
      ],
    );
  }

  getLogout() {
    if (_userName.isEmpty) {
      return Container();
    } else {
      return getItem('ic_logout', '退出登录', () {});
    }
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
