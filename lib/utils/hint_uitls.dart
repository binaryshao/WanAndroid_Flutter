import 'package:toast/toast.dart';

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

class HintUtils {
  static log(msg) {
    if (!isProduction) {
      print(msg);
    }
  }

  static toast(context, String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
