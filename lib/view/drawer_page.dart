import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/image_util.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/view/login/favorite_page.dart';
import 'package:wanandroid_flutter/view/login/login_page.dart';
import 'package:wanandroid_flutter/util/account_util.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';
import 'package:wanandroid_flutter/config/event.dart';
import 'package:wanandroid_flutter/util/apis.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String _userName = '';
  StreamSubscription loginSubscription;

  @override
  void initState() {
    super.initState();
    loginSubscription = eventBus.on<Login>().listen((event) {
      refreshUser();
    });
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
  void dispose() {
    super.dispose();
    loginSubscription.cancel();
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
      return getItem('ic_logout', '退出登录', () {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('退出登录'),
              content: Text(
                '确定要退出吗？',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Apis.logout().then((result) {
                      logout();
                      NavUtil.pop(context);
                    }).catchError((e) {
                      HintUtil.toast(context, e.toString());
                    });
                  },
                ),
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    NavUtil.pop(context);
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  logout() async {
    await AccountUtil.removeUser();
    await AccountUtil.removeCookie();
    HintUtil.toast(context, '已退出登录');
    setState(() {
      _userName = '';
    });
    eventBus.fire(Logout());
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
