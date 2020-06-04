import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:flutter_spterp/module/bottom_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_spterp/api.dart';
import 'news_detail.dart';

class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  RefreshController _refreshController;
  Map<String, dynamic> journalism = {};
  bool isLoading = false;
  int page = 1;
  Map<String, dynamic> pageMap = {};
  List<Map<String, dynamic>> dataList = [];
  var imageUrl = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _refreshController = RefreshController();
    _loadDate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发现',textAlign: TextAlign.center),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: getFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          shrinkWrap: true,
          children: dataList.map((contract) => _itemBuild(contract)).toList(),
        ),
      ),

    );
  }

  Widget _itemBuild(contract) {
    return GestureDetector(
      child: ListTile(
        leading: Container(
          constraints: BoxConstraints(
            maxWidth: 70,
            minWidth: 70,
          ),
          child: Image.network(
            baseUrl + "/journalism/images/" + contract['img'],
            fit: BoxFit.cover,
          ),
        ),
        title: Text("${contract['title']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("${contract['content']}",maxLines:1,overflow:TextOverflow.ellipsis),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child:Text("${contract['updateTime']}"),
            ),
          ],
        ),

      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JournalismDetailPage(contract['id'])));
      },
    );
  }

  Future _loadDate() async {
    if (!isLoading) {

      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> result = await journalismlist(
        page,
      );
      setState(() {
        pageMap = result;

        if (result['arr'] != null) {
          for (var item in result['arr']) {
            String content =item['content'];
            content = content.substring(3,content.length-4);
            item['content'] = content.replaceAll("<img", "");
            dataList.add(item);
          }
          pageMap.remove("arr");

        }
        isLoading = false;
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      page = 1;
      dataList = [];
    });
    try {
      await _loadDate();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  Future _onLoading() async {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    page++;
    await _loadDate();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
