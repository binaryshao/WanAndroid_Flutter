import 'package:shared_preferences/shared_preferences.dart';

const userNameKey = 'userName';
const cookieKey = 'cookie';

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

  static saveCookie(cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cookieKey, cookie);
  }

  static getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cookieKey);
  }

  static removeCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(cookieKey);
  }
}

