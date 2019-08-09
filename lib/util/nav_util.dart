import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid_flutter/view/webview_page.dart';

class NavUtil {
  static Future navTo(BuildContext context, Widget page) {
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
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

  static pop(BuildContext context) {
    Navigator.pop(context);
  }
}
