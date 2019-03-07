import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart';
void main () => runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'test',
      home: Scaffold(
        
        // 创建tabbar
        // appBar: AppBar(
        //   title: Text(
        //     '未登录',
        //     style: TextStyle(
        //       fontSize: 17.0,
        //       fontWeight: FontWeight.normal,
        //       color: Colors.black,
     
        //     ),
        //     ),
        //   backgroundColor: Colors.redAccent,
        //   // 阴影
        //   // elevation: 0.1,
        //    centerTitle: true,
        // ),

      body:  MinePageContent(),

      )
    );
   }
  }

// 我的页面
  class MinePageContent extends StatelessWidget{


  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel = const MethodChannel('com.pages.your/native_get');

  // 跳转到原生登录页面
  _iOSPushToVC() async {
    await methodChannel.invokeMethod('iOSFlutter', '参数');
  }
    @override
    Widget build(BuildContext context){
      return Container(
        child: Column(
          // 总的数组
          children: <Widget>[

            //  第一行 登录行
            new Container(
              margin: const EdgeInsets.only(top: 80.0,bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 90.0,
                    height: 90.0,
                    // 按钮
                    child: RaisedButton(
                      child: new Text("登录",style: TextStyle(fontSize: 22.0),),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        // var aa =window.physicalSize.width/window.devicePixelRatio;
                        // print(aa);
                        _iOSPushToVC();
                        },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)), 
                    )
                  )
                 


                ],

              ),
             ),
          
            // 分割线
             LineTips(),

          // 第二行
          new Container(
            child: Row(
              children: <Widget>[
               buildButtonColumn('images/3.png', '我的收藏'),
               buildButtonColumn('images/1.png', '我的评论'),
               buildButtonColumn('images/2.png', '我的点赞'),
               buildButtonColumn('images/4.png', '浏览历史'),
              ],

            ),
          ),

             // 分割线
             LineTips(),

          // listview
          new Container(
            color: Colors.white,
            width: window.physicalSize.width,
            height: 500.0,
            child: ListView(
                children: <Widget>[
                 buildListColumn(Icons.access_alarm, "我的关注"),
                 new Divider(),
                 buildListColumn(Icons.ac_unit, "我的钱包"),
                 new Divider(),
                 buildListColumn(Icons.access_time, "消息通知"),
                 LineTips(),
                 buildListColumn(Icons.accessibility_new, "扫一扫"),
                 new Divider(),
                 buildListColumn(Icons.backspace, "免流量看头条"),
                 new Divider(),
                 buildListColumn(Icons.cake, "阅读公益"),
                  LineTips(),
                 buildListColumn(Icons.dashboard, "用户反馈"),
                 new Divider(),
                 buildListColumn(Icons.face, "系统设置"),
                 new Divider(),

                ],



            ),



          )






          ],

        ),

      );
    }
  }




// 分割线
  class LineTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              // margin: const EdgeInsets.only(
              //   right: 10.0,
              // ),
              color: const Color(0xEEEEEEEE),
              height: 4.0,
            ),
          ),
         
        ],
      ),
    );
  }
}

ListTile buildListColumn(IconData icon,String text){

  return new ListTile(
         leading: Icon(icon),
         title:new Text(text),
         
  );
}


// 第二行 公共
 Column buildButtonColumn(String icon, String label) {
  
      return new Column(
        children: <Widget> [
          new Container(
            // var aa =window.physicalSize.width/window.devicePixelRatio;
            width: window.physicalSize.width/window.devicePixelRatio/4,
            height: 20.0,
            margin: const EdgeInsets.only(top: 12.0),
            child: Image.asset(icon),
          ),
     
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }

