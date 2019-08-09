import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid_flutter/widget/loading_view.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  final String title;

  const WebViewPage(this.url, this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebviewScaffold(
        url: url,
        withZoom: true,
        withJavascript: true,
        withLocalStorage: true,
        initialChild: LoadingView(),
      ),
    );
  }
}
