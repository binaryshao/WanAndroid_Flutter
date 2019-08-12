import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

class HintUtil {
  static log(msg) {
    if (!isProduction) {
      print(msg);
    }
  }

  static toast(context, String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  static alert(BuildContext context, String title, String msg,
      Function onConfirm, Function onCancel) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: onConfirm,
            ),
            FlatButton(
              child: Text('取消'),
              onPressed: onCancel,
            ),
          ],
        );
      },
    );
  }
}
