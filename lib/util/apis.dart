import 'package:wanandroid_flutter/util/http_util.dart';

class Apis {
  static articles(pageNo) {
    return HttpUtil.get('article/list/$pageNo/json');
  }

  static topArticles() {
    return HttpUtil.get('article/top/json');
  }

  static banner() {
    return HttpUtil.get('banner/json');
  }

  static wxChapters() {
    return HttpUtil.get('wxarticle/chapters/json');
  }

  static chapterArticles(chapterId) {
    return (pageNo) {
      return HttpUtil.get('wxarticle/list/$chapterId/$pageNo/json');
    };
  }

  static projectChapters() {
    return HttpUtil.get('project/tree/json');
  }

  static knowledgeTree() {
    return HttpUtil.get('tree/json');
  }

  static Future navigation() {
    return HttpUtil.get('navi/json');
  }

  static hotKeys() {
    return HttpUtil.get('hotkey/json');
  }

  static search(keyword) {
    return (pageNo) {
      return HttpUtil.post('article/query/$pageNo/json', body: {'k': keyword});
    };
  }

  static Future login(username, password) {
    return HttpUtil.post('user/login',
        body: {'username': username, 'password': password});
  }

  static favorite(pageNo) {
    return HttpUtil.get('lg/collect/list/$pageNo/json');
  }

  static Future register(username, password, passwordAgain) {
    return HttpUtil.post('user/register', body: {
      'username': username,
      'password': password,
      'repassword': passwordAgain
    });
  }

  static Future logout() {
    return HttpUtil.get('user/logout/json');
  }

  static Future collect(id) {
    return HttpUtil.post('lg/collect/$id//json');
  }

  static Future uncollect(id) {
    return HttpUtil.post('lg/uncollect_originId/$id//json');
  }

  static Future uncollectFromFavorite(id, originId) {
    return HttpUtil.post('lg/uncollect/$id//json',
        body: {'originId': originId});
  }

  static todo(pageNo) {
    return HttpUtil.get('lg/todo/v2/list/$pageNo/json');
  }

  static Future todoDelete(id) {
    return HttpUtil.post('lg/todo/delete/$id//json');
  }

  static Future todoAdd(title, content, date) {
    return HttpUtil.post('lg/todo/add/json', body: {
      'title': title,
      'content': content,
      'date': date,
    });
  }

  static Future todoUpdate(id, title, content, date, status) {
    return HttpUtil.post('lg/todo/update/$id/json', body: {
      'title': title,
      'content': content,
      'date': date,
      'status': status,
    });
  }
}
