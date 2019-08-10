import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/util/nav_util.dart';
import 'package:wanandroid_flutter/util/apis.dart';
import 'package:wanandroid_flutter/util/hint_uitl.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  var _userName, _password, _passwordAgain;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? '用户名不能为空...' : null,
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
                          validator: (value) =>
                              value.isEmpty ? '密码不能为空...' : null,
                          onSaved: (value) => _password = value,
                          decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            hintText: '请输入密码',
                            labelText: '密码',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          validator: (value) =>
                              value.isEmpty ? '请确认密码...' : null,
                          onSaved: (value) => _passwordAgain = value,
                          decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            hintText: '请再次输入密码',
                            labelText: '确认密码',
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
                              child: Text(_isLoading ? '注册中...' : '注册'),
                              onPressed: _isLoading ? null : _register,
                              textColor: Colors.white,
                              disabledTextColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              disabledColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavUtil.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            '已经有账号？点击去登录',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  _register() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if (_passwordAgain != _password) {
        HintUtil.toast(context, '两次密码不一致...');
      } else {
        setState(() {
          _isLoading = true;
        });
        Apis.register(_userName, _password, _passwordAgain).then((result) {
          HintUtil.toast(context, '注册成功');
          NavUtil.pop(context);
        }).catchError((e) {
          HintUtil.toast(context, e.toString());
        }).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }
}
