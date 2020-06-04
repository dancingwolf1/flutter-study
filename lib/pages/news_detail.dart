import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spterp/component/appbar.dart';

class JournalismDetailPage extends StatefulWidget {
  JournalismDetailPage(this.id);

  final int id;

  @override
  JournalismDetailState createState() => JournalismDetailState();
}

class JournalismDetailState extends State<JournalismDetailPage> {
  bool isLoaded = false;
  Map<String, dynamic> journalismDetailDate;

  TextStyle labelStyle = TextStyle(fontSize: 18.0, color: Colors.blueGrey);
  TextStyle valueStyle = TextStyle(fontSize: 18.0, color: Colors.black87);
  String title = "";
  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  _loadDate() async {
    Map<String, dynamic> _journalismDetailDate =
        await getJournalismDetail(widget.id);
    setState(() {
      journalismDetailDate = _journalismDetailDate;
      isLoaded = true;
    });
  }

  Widget _build() {
    return GestureDetector(
      child: ListView(
        children: <Widget>[
          Container(
            child: Html(data: "${journalismDetailDate['content']}"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "文章",isRightButton: false),
      body: isLoaded ? _build() : Container(),
    );
  }
}
