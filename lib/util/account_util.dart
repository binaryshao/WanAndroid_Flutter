import 'package:shared_preferences/shared_preferences.dart';

const userNameKey = 'userName';

class AccountUtil {
  static saveUserName(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, name);
  }

  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(userNameKey);
  }
}
