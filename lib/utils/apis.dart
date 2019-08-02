class Apis {
  static articles(pageNo) {
    return 'article/list/$pageNo/json';
  }

  static topArticles() {
    return 'article/top/json';
  }

  static banner() {
    return 'banner/json';
  }
}
