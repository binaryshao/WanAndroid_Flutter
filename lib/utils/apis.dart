import 'package:wanandroid_flutter/utils/http_utils.dart';

class Apis {
  static articles(pageNo) {
    return HttpUtils.get('article/list/$pageNo/json');
  }

  static topArticles() {
    return HttpUtils.get('article/top/json');
  }

  static banner() {
    return HttpUtils.get('banner/json');
  }

  static wxChapters() {
    return HttpUtils.get('wxarticle/chapters/json');
  }

  static chapterArticles(chapterId) {
    return (pageNo) {
      return HttpUtils.get('wxarticle/list/$chapterId/$pageNo/json');
    };
  }

  static projectChapters() {
    return HttpUtils.get('project/tree/json');
  }
}
