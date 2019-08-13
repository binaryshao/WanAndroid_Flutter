import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/view/webview_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于我们'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            getTitle('玩安卓-Flutter'),
            getContent('玩 Android 客户端，可以查看各种开发相关的知识，采用 Flutter 开发，内容已经比较完整。'),
            getContent('封装了加载中、空数据、错误、到达最底部等不同状态的视图，在错误时可以点击重新加载，具有较好的用户体验。'),
            getTitle('业务内容'),
            getContent('几乎对接了玩安卓的所有 API，主要包括以下内容：'),
            getContent('- 注册、登录'),
            getContent('- 收藏、取消收藏'),
            getContent('- 新增、编辑待办任务'),
            getContent('- 查看、搜索各类项目和文章'),
            getContent('- 网站导航、知识体系、公众号'),
            getTitle('用到的开源库'),
            getContent('http：网络请求'),
            getContent('flutter_webview_plugin：webview 插件'),
            getContent('toast：吐司'),
            getContent('shared_preferences：持久化键值对'),
            getContent('event_bus：事件总线'),
            getContent('datetime_picker_formfield：日期时间选择器'),
            getTitle('感谢'),
            getLink(
              context,
              '鸿神提供的数据源',
              'https://www.wanandroid.com/blog/show/2',
            ),
            getTitle('项目地址'),
            getLink(
              context,
              '玩安卓-Flutter',
              'https://github.com/binaryshao/WanAndroid_Flutter',
            ),
            getContent('如果觉得项目还不错，点个 star 鼓励下作者吧 o(╥﹏╥)o'),
            getContent('也欢迎大家发起 issue 或提交 PR'),
          ],
        ),
      ),
    );
  }

  getTitle(title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  getContent(content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        content,
      ),
    );
  }

  getLink(context, title, url) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          NavUtil.navTo(context, WebViewPage(url, title));
        },
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
