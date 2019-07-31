import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final Function retry;
  final String error;

  ErrorView({this.error = '无错误说明...', this.retry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: retry,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('加载失败 o(╥﹏╥)o'),
            getRetryHint(),
            Text(error),
          ],
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
