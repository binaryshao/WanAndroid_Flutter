import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/views/main/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩安卓-Flutter',
      theme: ThemeData(
        primaryColor: Colors.teal,
        backgroundColor: Colors.grey,
        accentColor: Color(0xFF26A69A),
        dividerColor: Colors.blueGrey,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ),
      home: MainPage(),
      routes: {},
    );
  }
}
