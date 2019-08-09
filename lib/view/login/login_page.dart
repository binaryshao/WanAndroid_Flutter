import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/util/account_util.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  var _userName, _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (value) => value.isEmpty ? '用户名不能为空...' : null,
                  onSaved: (value) => _userName = value,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: '请输入用户名',
                    labelText: '用户名',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    validator: (value) => value.isEmpty ? '密码不能为空...' : null,
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: '请输入密码',
                      labelText: '密码',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 200,
                      height: 45,
                      child: RaisedButton(
                        child: Text('登录'),
                        onPressed: _isLoading ? null : _login,
                        textColor: Colors.white,
                        disabledTextColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        disabledColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _login() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print('name: $_userName\npassword:$_password');
      setState(() {
        _isLoading = true;
      });
      Apis.login(_userName, _password).then((result) {
        loginSuccess(result['nickname']);
      }).catchError((e) {
        HintUtil.toast(context, e.toString());
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  loginSuccess(name) async {
    await AccountUtil.saveUserName(name);
    HintUtil.toast(context, '登录成功');
    NavUtil.pop(context);
  }
}
