import 'package:flutter/material.dart';

class ImageUtil {
  static String getImagePath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static Widget getRoundImage(String imgName, double radius,
      {String format: 'png'}) {
    /// 任选一种圆形图片实现方式
    return _getRoundImage(imgName, radius, 0, format);
  }

  static Widget _getRoundImage(
      String imgName, double radius, int type, String format) {
    switch (type) {
      case 0:
        return CircleAvatar(
          backgroundImage: AssetImage(
            getImagePath(imgName, format: format),
          ),
          radius: radius,
        );
        break;
      case 1:
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            getImagePath(imgName, format: format),
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
          ),
        );
        break;
      case 2:
        return ClipOval(
          child: Image.asset(
            getImagePath(imgName, format: format),
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
          ),
        );
        break;
      case 3:
        return Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                getImagePath(imgName, format: format),
              ),
            ),
          ),
        );
        break;
    }
  }
}
