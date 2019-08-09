import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'hint_uitl.dart';

const BASE_URL = "https://www.wanandroid.com";

String getRequestUrl(path) {
  return '$BASE_URL/$path';
}

Future proceedResponse(url, Future future) {
  return future.then((response) {
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Future.value(jsonResponse);
    } else {
      var msg = '请求失败 ${response.statusCode}';
      HintUtil.log(msg);
      return Future.error(msg);
    }
  }).then((jsonResponse) {
    HintUtil.log('$url json返回如下：\n$jsonResponse');
    if (jsonResponse != null) {
      if (jsonResponse['errorCode'] == 0) {
        return jsonResponse['data'];
      } else {
        var msg = "业务失败：$jsonResponse['errorMsg']";
        HintUtil.log(msg);
        return Future.error(msg);
      }
    }
  });
}

class HttpUtil {
  static Future get(String path, {Map<String, String> headers}) {
    var url = getRequestUrl(path);
    HintUtil.log('get-请求：$url');
    return proceedResponse(url, http.get(url, headers: headers));
  }

  static Future post(String path, {Map<String, String> headers, body}) {
    var url = getRequestUrl(path);
    HintUtil.log('post-请求：$url\n参数：$body');
    return proceedResponse(url, http.post(url, headers: headers, body: body));
  }
}
