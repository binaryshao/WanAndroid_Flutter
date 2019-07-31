const bool isProduction = const bool.fromEnvironment("dart.vm.product");

class HintUtils {
  static log(msg) {
    if (!isProduction) {
      print(msg);
    }
  }
}
