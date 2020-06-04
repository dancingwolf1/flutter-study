import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
/// 屏幕适配
adaptation(var context) {
  ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
  ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  ScreenUtil.instance =
  ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
    ..init(context);
}