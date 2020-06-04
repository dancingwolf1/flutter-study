import 'package:pull_to_refresh/pull_to_refresh.dart';

ClassicFooter getFooter() {
  return ClassicFooter(
      loadingText: "加载中...",
      failedText: '加载失败,点击重试！',
      noDataText: "没有更多数据！",
      idleText: "加载更多");
}
