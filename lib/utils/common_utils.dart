import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid_flutter/views/webview_page.dart';

class CommonUtils {
  static String getImagePath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static navToWeb(BuildContext context, String url, String title) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => WebViewPage(
                  url,
                  title,
                )));
  }
}
