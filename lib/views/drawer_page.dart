import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          height: 150,
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              '个人信息',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Text(
                '你打开了抽屉!',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
