import 'package:flutter/material.dart';
import 'dart:async';

class HomeBanner extends StatefulWidget {
  final List _bannerList;
  final Function(dynamic item) _onTap;

  HomeBanner(
    this._bannerList,
    this._onTap,
  );

  @override
  State createState() {
    return _HomeBannerState();
  }
}

class _HomeBannerState extends State<HomeBanner> {
  PageController _pageController;
  Timer _timer;
  int realIndex = 1;
  int virtualIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: realIndex,
    );
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _pageController.animateToPage(
        realIndex + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            children: _buildBanner(),
            controller: _pageController,
            onPageChanged: _onPageChanged,
          ),
          _buildHint(),
        ],
      ),
    );
  }

  _buildBanner() {
    List<Widget> list = [];
    list.add(_buildBannerItem(
        widget._bannerList.elementAt(widget._bannerList.length - 1)));
    list.addAll(widget._bannerList
        .map((item) => _buildBannerItem(item))
        .toList(growable: false));
    list.add(_buildBannerItem(widget._bannerList.elementAt(0)));
    return list;
  }

  Widget _buildBannerItem(item) {
    return GestureDetector(
      onTap: () {
        widget._onTap(item);
      },
      child: Image.network(
        item['imagePath'],
        fit: BoxFit.fill,
      ),
    );
  }

  _buildHint() {
    var item = widget._bannerList.elementAt(virtualIndex);
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              item['title'],
              style: hintStyle,
            ),
          ),
          Text(
            '${virtualIndex + 1}/${widget._bannerList.length}',
            style: hintStyle,
          ),
        ],
      ),
    );
  }

  final hintStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  _onPageChanged(index) {
    realIndex = index;
    int count = widget._bannerList.length;
    if (index == 0) {
      virtualIndex = count - 1;
      _pageController.jumpToPage(count);
    } else if (index == count + 1) {
      virtualIndex = 0;
      _pageController.jumpToPage(1);
    } else {
      virtualIndex = index - 1;
    }
    setState(() {});
  }
}
