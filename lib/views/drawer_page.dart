import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/utils/common_utils.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        CommonUtils.getImagePath('ic_avatar'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    '还没有登录...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: Image.asset(
                CommonUtils.getImagePath('ic_favorite_not'),
                width: 20,
                height: 20,
                color: Colors.black54,
              ),
              title: Text('收藏夹'),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                CommonUtils.getImagePath('ic_todo'),
                width: 20,
                height: 20,
                color: Colors.black54,
              ),
              title: Text('任务清单'),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                CommonUtils.getImagePath('ic_about'),
                width: 20,
                height: 20,
                color: Colors.black54,
              ),
              title: Text('关于'),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                CommonUtils.getImagePath('ic_logout'),
                width: 20,
                height: 20,
                color: Colors.black54,
              ),
              title: Text('退出登录'),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
