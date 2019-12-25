import 'package:flutter/material.dart';
import 'main_view.dart';
import 'led_view.dart';
import 'fan_view.dart';
import 'pump_view.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'constants.dart';
import 'singleton_data.dart';


//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//
//      title: 'Flutter Time Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MainView(),
//    );
//  }
//}
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "TabBar Inside AppBar Demo",
  theme: new ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green[800], //Changing this will change the color of the TabBar
    accentColor: Colors.cyan[600],
  ),
  home: TabBarInsideAppBarDemo(),
));


class TabBarInsideAppBarDemo extends StatefulWidget {
  @override
  _TabBarInsideAppBarDemoState createState() => _TabBarInsideAppBarDemoState();
}

class _TabBarInsideAppBarDemoState extends State<TabBarInsideAppBarDemo>
    with SingleTickerProviderStateMixin {
  TabController tabController;
 // Socket socket;
  var singledata = Singleton.instance;

  connectserver() async
  {

    singledata.testrunapp = "Run connect";
    singledata.socket = await Socket.connect(Constants.IP, Constants.PORT,timeout: Duration (seconds: 5));
    singledata.socket.listen((List<int> event){
      //print(utf8.decode(event));
      String _str = utf8.decode(event);
      print("MAIN =>>>>>>>>>${_str}");
      setState(() {
        if (_str.length > 1)
          {
            List<String> _list = _str.split(",");
            _list.removeAt(_list.length - 1);
            List<List<String>> listdata = new List<List<String>>();
            List<String> liststatus = new List<String>() ;
            for(int i =0; i<_list.length; i++)
            {
              if (_list[i].length > 0)
              {
                List<String> list1 = _list[i].split("|");
                listdata.add(list1);
              }
            }
            if (listdata.length >0) {
              if (listdata[0][0] == Constants.PREFIX_STATIC) {
                singledata.temperature = listdata[0][1];
                singledata.humidity = listdata[0][2];
                singledata.pH = listdata[0][3];
                singledata.waterLevel = listdata[0][4];
                singledata.tds = listdata[0][5];
              }
              else if (listdata[0][0] == Constants.PREFIX_LED1)
              {
                print("listdata[0][0]     ${listdata[0][0]}");
                List<double> listbrightness = new List<double>();
                for (int i = 0; i <listdata.length; i++)
                {
                  double a = double.tryParse(listdata[i][1]);
                  listbrightness.add(a);
                  if (listdata[i][2] == Constants.VALUE_ON)
                  {
                    liststatus.add(Constants.STATUS_ON);
                  }
                  else
                  {
                    liststatus.add(Constants.STATUS_OFF);
                  }
                }
                // lưu data nhận được để hiển thị
                singledata.valueBrightness = listbrightness.map((element)=>element).toList();
                singledata.statusLed = liststatus.map((element)=>element).toList();
                singledata.alarmLed = listdata.map((element)=>element).toList();
                singledata.lengthLed = listbrightness.length;
              }
              else if (listdata[0][0] == Constants.PREFIX_FAN1)
              {
                for (int i = 0; i <listdata.length; i++)
                {
                  if (listdata[i][1] == Constants.VALUE_ON)
                    liststatus.add(Constants.STATUS_ON);
                  else
                    liststatus.add(Constants.STATUS_OFF);
                }
                singledata.statusFan = liststatus.map((element)=>element).toList();
                singledata.alarmFan = listdata.map((element)=>element).toList();
                singledata.lengthFan = liststatus.length;
              }
              else if (listdata[0][0] == Constants.PREFIX_PUMP)
              {
                for (int i = 0; i <listdata.length; i++)
                {
                  if (listdata[i][1] == Constants.VALUE_ON)
                    liststatus.add(Constants.STATUS_ON);
                  else
                    liststatus.add(Constants.STATUS_OFF);
                }
                singledata.statusPump = liststatus.map((element)=>element).toList();
                singledata.lengthPump = liststatus.length;
              }
              else if (listdata[0][0] == Constants.APP_BUSY)
              {
                print("singledata.statusApp =>>>>>>>>>${singledata.statusApp}");
                singledata.statusApp = false;
                print("singledata.statusApp =>>>>>>>>>${singledata.statusApp}");
              }
              else if (listdata[0][0] == Constants.APP_RUN)
              {
                print("singledata.statusApp =>>>>>>>>>${singledata.statusApp}");
                singledata.statusApp = true;
                print("singledata.statusApp =>>>>>>>>>${singledata.statusApp}");
              }
            }
          }
      });
    });

    singledata.socket.add(utf8.encode('START Main'));
    await Future.delayed(Duration(seconds: 5));
  }
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    connectserver();
  }

  @override
  void dispose() {
    tabController.dispose();
    singledata.socket.close();
    singledata.socket.destroy();
    super.dispose();
  }

  Widget getTabBar() {

    return TabBar(controller: tabController,indicatorColor: Colors.lime, tabs: [
      Tab(text: "Home", icon: Icon(Icons.home)),
      Tab(text: "Led", icon: Icon(Icons.lightbulb_outline)),
      Tab(text: "Fan", icon: new Image.asset('image/fan-24-tab.png')),
      Tab(text: "Pump", icon: new Image.asset('image/pump-24-tab.png')),

    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(controller: tabController, children: <Widget>[
      MainView(),
      LedView(),
      FanView(),
      PumpView(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: getTabBar(),
          ),
        ),
        body: getTabBarPages());
  }
}