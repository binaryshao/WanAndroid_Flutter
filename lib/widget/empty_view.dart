import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final Function retry;

  EmptyView({this.retry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: retry,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '暂无数据 o(╥﹏╥)o',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              getRetryHint(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRetryHint() {
    if (retry != null) {
      return Text('点击重试');
    }
    return Container();
  }
}
