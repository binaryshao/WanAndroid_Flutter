import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              '加载中...',
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
