import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/amap/utils/misc.dart';
import 'package:flutter_spterp/component/amap/utils/utils.export.dart';
import 'package:flutter_spterp/component/amap/widgets/button.widget.dart';
import 'package:flutter_spterp/component/amap/widgets/dimens.dart';
import 'package:flutter_spterp/pages/navigation/draw_point.screen.dart';


class KeywordPoiSearchScreen extends StatefulWidget {
  @override
  _KeywordPoiSearchScreenState createState() => _KeywordPoiSearchScreenState();
}

class _KeywordPoiSearchScreenState extends State<KeywordPoiSearchScreen> {
  Map resultData = {};

  var local;
  TextEditingController _queryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocal();
  }

  _loadLocal() async {
    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );
    if (await Permissions().requestPermission()) {
      var _amapLocation = AMapLocation();
      _amapLocation.init();
      _amapLocation.getLocation(options).then(
        (local) {
          setState(() {
            this.local = local.toJson();
            _cityController.text = this.local["city"];
          });
        },
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('权限不足')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索目的地'),
      ),
//      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入目的地',
//                border: OutlineInputBorder(),
              ),
              controller: _queryController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入目的地';
                }
              },
            ),
            SPACE_NORMAL,
            TextFormField(
              decoration: InputDecoration(
                hintText: '输入城市',
//                border: OutlineInputBorder(),
              ),
              controller: _cityController,
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入城市';
                }
              },
            ),
            SPACE_NORMAL,
            Button(
              label: '开始搜索',
              onPressed: (context) async {
                if (!Form.of(context).validate()) {
                  return;
                }
                loading(
                  context,
                  AMapSearch().searchPoi(
                    PoiSearchQuery(
                      query: _queryController.text,
                      city: _cityController.text,
                    ),
                  ),
                )
                    .then((poiResult) {
//                      print(poiResult);
                      setState(() {
                        this.resultData = poiResult.toJson();
//                        _result = jsonFormat(poiResult.toJson());
                      });
                    })
                    .catchError((e) => showError(context, e.toString()))
                    .then((_) async {
                      var latLngs = [];

                      /// 取坐标存数组
                      for (var item in this.resultData['pois']) {
                        latLngs.add(LatLng(item['latLonPoint']['latitude'],
                            item['latLonPoint']['longitude']));
                      }

                      var title = _queryController.text;
                      Map marker = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  DrawPointScreen(latLngs, title: title)));
//                      print(marker);
                      /// 将选择的坐标返回给送货页面
                      Navigator.pop(context, marker);
                    });
              },
            ),
//            Text(_result),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
