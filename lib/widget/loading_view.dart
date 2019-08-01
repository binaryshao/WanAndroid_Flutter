import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
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
      ),
    );
  }
}
