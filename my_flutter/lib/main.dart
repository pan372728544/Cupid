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
        // 跳转到其他页面
       _pushSecondView(String ti,String des){
    
          Navigator.push(context, 
                    new MaterialPageRoute(
                      builder: (context) =>new SecondScreen(product: Product(ti, des),)
                    ),
                    );
        }

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

                  new FlatButton(
                   child: buildListColumn(Icons.access_alarm, "我的关注"),
                   onPressed:(){
                    //  print('aaaaaa');
                    _pushSecondView('我的关注','描述信息-我的关注！->点击返回');
                    }
                  ),
              
                 new Divider(),
                  new FlatButton(
                 child: buildListColumn(Icons.ac_unit, "我的钱包"),
                      onPressed:(){
                     _pushSecondView("我的钱包",'描述信息-我的钱包！->点击返回');
                    }
                  ),
                 new Divider(),
                 new FlatButton(
                 child: buildListColumn(Icons.access_time, "消息通知"),
                      onPressed:(){
                        _pushSecondView('消息通知','描述信息-消息通知！->点击返回');
                    }
                  ),
                 LineTips(),
                 new FlatButton(
                 child: buildListColumn(Icons.accessibility_new, "扫一扫"),
                      onPressed:(){
                        _pushSecondView('扫一扫','描述信息-扫一扫！->点击返回');
                    }
                  ),
                 new Divider(),
                 new FlatButton(
                 child: buildListColumn(Icons.backspace, "免流量看头条"),
                      onPressed:(){
                        _pushSecondView('免流量看头条','描述信息-免流量看头条！->点击返回');
                    }
                  ),
                 new Divider(),
                 new FlatButton(
                 child: buildListColumn(Icons.cake, "阅读公益"),
                      onPressed:(){
                        _pushSecondView('阅读公益','描述信息-阅读公益！->点击返回');
                    }
                  ),
                  LineTips(),
                  new FlatButton(
                 child: buildListColumn(Icons.dashboard, "用户反馈"),
                      onPressed:(){
                       _pushSecondView('用户反馈','描述信息-用户反馈！->点击返回');
                    }
                  ),
                 new Divider(),
                 new FlatButton(
                 child: buildListColumn(Icons.face, "系统设置"),
                      onPressed:(){
                        _pushSecondView('系统设置','描述信息-系统设置！->点击返回');
                    }
                  ),
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

class Product{
  final String title;  //商品标题
  final String description;  //商品描述
  Product(this.title,this.description);
}

// flutter跳转的第二个页面
class SecondScreen extends StatelessWidget{
  final Product product;
  SecondScreen({Key key ,@required this.product}):super(key:key);
 @override

 Widget build(BuildContext context){
   return Scaffold(

     appBar: AppBar(
       title: Text(
         '${product.title}',
         style: TextStyle(
           fontSize: 20.0,
            fontWeight: FontWeight.normal,
              color: Colors.white,

         ),
       ),
       backgroundColor: Colors.red,
     ),

    
     body: Container(
       height: 200.0,
       width: 200.0,
      margin: const EdgeInsets.only(top: 200.0,left: 100.0),
     child: RaisedButton(
        color: Colors.lightBlue,
        child: Text('${product.description}',style: TextStyle(fontSize: 20.0,color: Colors.white),),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      )
     

     );

 }


}