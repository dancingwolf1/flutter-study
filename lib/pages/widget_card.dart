import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input.dart';



class CardPage extends StatefulWidget {
  @override
  CardPageState createState() => CardPageState();
}



class CardPageState extends State<CardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

String dropdownValue="1";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: getAppBar(context, "Card", funnel: () {
            _scaffoldKey.currentState.openEndDrawer();
          },

          ),
          body:  Container(
              padding: EdgeInsets.only(right: 20),

            child: ListView(
              children: <Widget>[
                Card(
                  elevation: 15.0,
                  margin:EdgeInsets.all(20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),  //设置圆角
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[

                                TextField(
                                  //TextCapitalization.words 将每个单词的首字母大写
                                  //TextCapitalization.sentences 将首字母大写
                                  //TextCapitalization.characters 将所有字母大写
                                  textCapitalization: TextCapitalization.words ,
                                  //键盘类型
                                    //TextInputType.text 字母
                                    //TextInputType.number 数字
                                    //TextInputType.datetime 日期
                                    //TextInputType.emailAddress 邮箱
                                  keyboardType: TextInputType.text,
                                    onChanged:_print,
                                  decoration: InputDecoration(
                                    //内容的内边距
                                    contentPadding: EdgeInsets.all(10.0),
                                    icon: Icon(Icons.person),
                                    //提示文本
                                    labelText: '请输入你的用户名',
                                    helperText: '请输入注册的用户名',
                                  ),
                                  //键盘插件按钮样式
                                  textInputAction: TextInputAction.go,
                                  //设置光标样式
                                  //          cursorColor: Colors.green,
                                  //          cursorRadius: Radius.circular(16.0),
                                  //          cursorWidth: 16.0,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    icon: Icon(Icons.lock),
                                    labelText: '请输入密码',
                                  ),
                                  //密码隐藏效果
                                  obscureText: true,
                                ),
                                inputWrite("联系电话",(value) {
                                  setState(() {
                                  });
                                },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                new Divider(),
                Container(height: 30,color: Colors.green, ),//标题与内容的隔离线
                Card(
                  elevation: 15.0,  //设置阴影
                  color: Colors.brown,

                  margin:EdgeInsets.all(20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),  //设置圆角
                  child: new Column(  // card只能有一个widget，但这个widget内容可以包含其他的widget
                      children: [
                        new ListTile(
                          title: new Text('标题',
                              style: new TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: new Text('子标题'),
                          leading: new Icon(
                            Icons.restaurant_menu,
                            color: Colors.blue[500],
                          ),
                        ),
                        new Divider(),//标题与内容的隔离线
                        new ListTile(
                          leading: //最左侧的头部，参数是一个widget
                          new Icon(
                            Icons.contact_phone,
                            color: Colors.blue[500],
                          ),
                          title://控件的title(参数是widget，这里text为例)
                          new Text('内容一title',
                              style: new TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: //富文本标题（参数是widget）
                          new Text('内容一subtitle',
                              style: new TextStyle(fontWeight: FontWeight.w500)),
                          trailing://展示在title后面最末尾的后缀组件（参数是widget）
                          new Icon(Icons.save),
                          onTap: //点击事件
                              () {
                            print('点击');
                          },

                        ),
                        new ListTile(
                          title: new Text('内容二'),
                          leading: new Icon(
                            Icons.contact_mail,
                            color: Colors.blue[500],
                          ),
                        ),
                          /*
                    Row以及Column的源代码就一个构造函数，具体的实现全部在它们的父类Flex中
                    Flex的构造函数就比Row和Column的多了一个参数。Row跟Column的区别，正是这个direction参数的不同。
                    当为Axis.horizontal的时候，则是Row，当为Axis.vertical的时候，则是Column。

                    源码解读
                    计算出flex的总和，并找到最后一个设置了flex的child；
                    对不包含flex的child，根据交叉轴对齐方式，对齐进行调整，并计算出主轴方向上所占区域大小；
                    计算出每一份flex所占用的空间，并根据交叉轴对齐方式，对包含flex的child进行调整；
                    如果交叉轴设置为baseline对齐，则计算出整体的baseline值；
                    按照主轴对齐方式，对child进行调整；
                    最后，根据交叉轴对齐方式，对所有child位置进行调整，完成布局。
                     */
                        Row(
                          /*
                    主轴方向上的对齐方式，会对child的位置起作用，默认是start。
                        center：将children放置在主轴的中心；
                        end：将children放置在主轴的末尾；
                        spaceAround：将主轴方向上的空白区域均分，使得children之间的空白区域相等，但是首尾child的空白区域为1/2；
                        spaceBetween：将主轴方向上的空白区域均分，使得children之间的空白区域相等，首尾child都靠近首尾，没有间隙；
                        spaceEvenly：将主轴方向上的空白区域均分，使得children之间的空白区域相等，包括首尾child；
                        start：将children放置在主轴的起点；
                        其中spaceAround、spaceBetween以及spaceEvenly的区别，就是对待首尾child的方式。其距离首尾的距离分别是空白区域的1/2、0、1。

                     */
                          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                          /*
                    在主轴方向占有空间的值
                    max：根据传入的布局约束条件，最大化主轴方向的可用空间；
                    min：与max相反，是最小化主轴方向的可用空间；
                     */
                          mainAxisSize:MainAxisSize.max,
                          /*
                    children在交叉轴方向的对齐方式，与MainAxisAlignment略有不同。
                      baseline：在交叉轴方向，使得children的baseline对齐；
                      center：children在交叉轴上居中展示；
                      end：children在交叉轴上末尾展示；
                      start：children在交叉轴上起点处展示；
                      stretch：让children填满交叉轴方向；
                     */
                          crossAxisAlignment:CrossAxisAlignment.start,
                            /*
                        定义了children摆放顺序，默认是down。
                        down：从top到bottom进行布局；
                          up：从bottom到top进行布局。
                          top对应Row以及Column的话，就是左边和顶部，bottom的话，则是右边和底部。
                       */

                          verticalDirection:VerticalDirection.down,

                          textBaseline:TextBaseline.alphabetic,

                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Colors.red,
                                padding: EdgeInsets.all(5.0),
                                child: Text("123"),
                              ),
                              flex: 1,//flex 将每行平分成几个flex的和，相应的flex表示占的比例
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.yellow,
                                padding: EdgeInsets.all(5.0),
                                child: Text("456"),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(5.0),
                                child: Text("789"),
                              ),
                              flex: 1,
                            ),
                          ],
                        )
                      ] ),

                ),
                Card(
                  elevation: 15.0,  //设置阴影
                  color: Colors.grey,
                  margin:EdgeInsets.all(20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),  //设置圆角
                  child: new Column(
                    children: <Widget>[
                      Center(
                        //加载本地图片增加placeholder
                        child: FadeInImage.assetNetwork(
                            placeholder: "images/loading.gif",
                            image: "https://gss0.bdstatic.com/-4o3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=eea934627f8da9775a228e79d138937c/b3b7d0a20cf431ad6fd6b4684736acaf2edd985f.jpg",
                        height: 115,),
                      ),
                      /*Center(
                        //加载网络图片增加placeholder
                        child: FadeInImage.memoryNetwork(//placeholder: kTransparentImage,
                            image: "https://img-bss.csdn.net/1573033066893.jpg",height: 115.0,),
                      ),*/
                    ],
                  ),
                ),
                Container(
                  height: 200,//GridView.count 外层需要指定高度
                  child: GridView.count(
                    //水平子Widget之间间距
                    crossAxisSpacing: 5.0,
                    //垂直子Widget之间间距
                    mainAxisSpacing: 15.0,
                    //GridView内边距
                    padding: EdgeInsets.all(5.0),
                    //一行的Widget数量
                    crossAxisCount: 10,
                    //子Widget宽高比例
                    childAspectRatio: 1.0,
                    //子Widget列表
                    children: getWidgetList(),
                  ),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Container(
                  height: 200.0,
                  child: GridView.builder(
                      itemCount: getDataList().length,
                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                      gridDelegate: //构建方式之一SliverGridDelegateWithFixedCrossAxisCount
                      SliverGridDelegateWithFixedCrossAxisCount(
                        //横轴元素个数
                          crossAxisCount: 4,
                          //纵轴间距
                          mainAxisSpacing: 20.0,
                          //横轴间距
                          crossAxisSpacing: 10.0,
                          //子组件宽高长度比例
                          childAspectRatio: 1.0),
                      itemBuilder: (BuildContext context, int index) {
                        //Widget Function(BuildContext context, int index)
                        return getItemContainer(getDataList()[index]);
                      }),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Container(
                  height: 200,
                  child: GridView.builder(
                    itemCount: getDataList().length,
                    itemBuilder: (BuildContext context, int index) {
                      return getItemContainer(getDataList()[index]);
                    },
                    /*
                      GridView的构建方式之二SliverGridDelegateWithMaxCrossAxisExtent，水平方向元素个数不再固定，
                      其水平个数也就是有几列，由maxCrossAxisExtent和屏幕的宽度以及padding和mainAxisSpacing等决定
                     */
                    gridDelegate:
                    SliverGridDelegateWithMaxCrossAxisExtent(
                      //单个子Widget的水平最大宽度
                        maxCrossAxisExtent: 40,
                        //垂直单个子Widget之间间距
                        mainAxisSpacing: 20.0,
                        //水平单个子Widget之间间距
                        crossAxisSpacing: 10.0
                    ),
                  ),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Container(
                  height: 200,
                  child:  GridView.custom(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //一行最多显示几个
                        crossAxisCount: 5,
                        //纵向最小间距
                        mainAxisSpacing: 10.0,
                        //横向最小间距
                        crossAxisSpacing: 20.0,
                      ),
                      childrenDelegate: SliverChildBuilderDelegate((context, position) {
                        return getItemContainer(getDataList()[position]);
                      }, childCount: getDataList().length)),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Center(
                  widthFactor: 2.0,//如果widthFactor是2.0，那么widget的宽度将始终是其子宽度的两倍。
                  heightFactor: 2.0,//如果heightFactor是2.0，那么widget的高度将始终是其子高度的两倍。
                  child: Container(
                    color: Color(0xfff48fb1),
                    width: 90.0,
                    height: 50.0,
                  ),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Container(
                  child: FloatingActionButton(
                    onPressed: () => print("FloatingActionButton"),
                    child: Text("button"),
                    tooltip: "按这么长时间干嘛",
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.blue,
                    mini: true,//控制大小
                    //shape: CircleBorder(),//形状圆形
                    shape: BeveledRectangleBorder(),//形状长方形
                  ),
                ),
                Container(height: 30,color: Colors.green, ),
                new Divider(),
                Container(

                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.alarm),
                    label: Text("文本"),
                    onPressed: () {print("alarm");},
                  ),
                ),
                new Divider(),
                Container(
                    child: Offstage(
                      offstage: false,
                      child: Container(
                        color: Colors.yellow,
                        child: Text("Offstage组件,控制显示隐藏widget"),
                      ),
                    ),
                ),
                new Divider(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text("下拉菜单"),
                      Container(
                        child: Column(
                          children: <Widget>[
                            new Center(
                              child: new DropdownButton(
                                items: <DropdownMenuItem<String>>[
                                  DropdownMenuItem(child: Text("1111",),value: "1",),
                                  DropdownMenuItem(child: Text("2222",),value: "2",),
                                  DropdownMenuItem(child: Text("3333",),value: "3",),
                                  DropdownMenuItem(child: Text("4444",),value: "4",),
                                ],
                                hint:new Text("提示信息"),// 当没有初始值时显示
                                onChanged: (selectValue){//选中后的回调
                                  setState(() {
                                    dropdownValue=selectValue;
                                    print(selectValue) ;
                                  });
                                },
                                value: dropdownValue,// 设置初始值，要与列表中的value是相同的
                                elevation: 10,//设置阴影
                                style: new TextStyle(//设置文本框里面文字的样式
                                    color: Colors.green,
                                    fontSize: 15
                                ),
                                iconSize: 30,//设置三角标icon的大小
                                underline: Container(height: 1,color: Colors.blue,),// 下划线
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                new Divider(),


              ],
            ),


        ),
          /*
          设置悬浮按钮在页面的位置
          //centerDocked 底部中间
          //endDocked 底部右侧
          //centerFloat 中间偏上
          //endFloat 底部偏上
           */
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () => print("FloatingActionButton"),
            child: Text("button"),
          ),
          drawer:   UserAccountsDrawerHeader(
            accountName: Text('刘龙宾'),
            accountEmail: Text('liulongbin1314@outlook.com'),
            currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
            'https://images.gitee.com/uploads/91/465191_vsdeveloper.png'),
            ),
            decoration: BoxDecoration(
            // 设置背景图片
            image: DecorationImage(
            // 控制图片填充效果
            fit: BoxFit.fill,
            // 指定图片地址
            image: NetworkImage(
            'http://www.liulongbin.top:3005/images/bg1.jpg'))),
                  )

        )],
    );


  }


//GridView.count使用的数据
  List<String> getDataList() {
    List<String> list = [];
    for (int i = 0; i < 100; i++) {
      list.add(i.toString());
    }
    return list;
  }
  List<Widget> getWidgetList() {
    return getDataList().map((item) => getItemContainer(item)).toList();
  }
  Widget getItemContainer(String item) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
	overflow: TextOverflow.ellipsis,//设置Text过长三个点显示
      ),
      color: Colors.blue,
    );
  }

  //输出文字
  void _print(String str){
    print("文字输出");
  }
}
