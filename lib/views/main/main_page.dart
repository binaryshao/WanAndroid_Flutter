import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/views/main/home_page.dart';
import 'package:wanandroid_flutter/views/main/wechat_page.dart';
import 'package:wanandroid_flutter/views/main/project_page.dart';
import 'package:wanandroid_flutter/views/main/navigation_page.dart';
import 'package:wanandroid_flutter/views/main/knowledge_tree_page.dart';
import 'package:wanandroid_flutter/views/drawer_page.dart';
import 'package:wanandroid_flutter/utils/common_utils.dart';
import 'package:wanandroid_flutter/utils/hint_uitls.dart';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid_flutter/views/search_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _Item {
  String name, icon;

  _Item(this.name, this.icon);
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _pages = [
    HomePage(),
    WechatPage(),
    ProjectPage(),
    NavigationPage(),
    KnowledgeTreePage(),
  ];
  final _bottomItems = [
    _Item('首页', 'ic_home'),
    _Item('公众号', 'ic_wechat'),
    _Item('项目', 'ic_project'),
    _Item('网站导航', 'ic_navigation'),
    _Item('知识体系', 'ic_dashboard'),
  ];
  List<BottomNavigationBarItem> bottomItemList;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    if (bottomItemList == null) {
      bottomItemList = _bottomItems
          .map((item) => BottomNavigationBarItem(
              icon: Image.asset(
                CommonUtils.getImagePath(item.icon),
                width: 25,
                height: 25,
                color: Colors.grey,
              ),
              activeIcon: Image.asset(
                CommonUtils.getImagePath(item.icon),
                width: 25,
                height: 25,
                color: Colors.teal,
              ),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 16),
              )))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerPage(),
      ),
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? "玩安卓"
            : _bottomItems.elementAt(_selectedIndex).name),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomItemList,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(_selectedIndex);
          });
        },
      ),
      body: PageView(
        children: _pages,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
