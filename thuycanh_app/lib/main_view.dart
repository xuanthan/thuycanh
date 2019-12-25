import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'constants.dart';
import 'singleton_data.dart';
import 'alarm_view.dart';

class MainView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Control Device"),
//        backgroundColor: Color(0xFF86C98A),
//      ),

      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  Timer _timer;
  int _start = 3;

  Socket socket;
  var singleData = Singleton.instance;
  // khai bao bien luu do sang cua den
  List<double> brightness = [20.0,20.0,20.0,20.0];
  // khai bao bien luu trang thai cua device
  String statusPUMP = Constants.STATUS_ON;
  List<String> statusFan = [Constants.STATUS_ON,Constants.STATUS_ON,Constants.STATUS_ON,Constants.STATUS_ON];
  List<String> statusLed = [Constants.STATUS_ON,Constants.STATUS_ON,Constants.STATUS_ON,Constants.STATUS_ON];
  List<List<String>> alarmFan = [null,null,null,null];
  List<List<String>> alarmLed = [null,null,null,null];
// Khai bao bien luu gia tri
  String temperature = "20";
  String humidity = "70";
  String pH = "7";
  String waterLevel = "80";
  String tds = "100";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            //    timer.cancel();
            _start = 3;
            setState(() {
              print("singleData.temperature   ${singleData.temperature }");
              if (singleData.temperature != null)
              {
                temperature = singleData.temperature;
              }
              if (singleData.humidity != null )
                humidity = singleData.humidity;
              if (singleData.pH != null)
                pH = singleData.pH;
              if (singleData.waterLevel != null)
                waterLevel = singleData.waterLevel;
              if (singleData.tds != null)
                tds = singleData.tds;
              if (singleData.statusLed != null)
                {
                  for (int j=0; j < singleData.statusLed.length; j++)
                  {
                    if (j < (statusLed.length))
                    {
                      statusLed[j] = singleData.statusLed[j];
                      brightness[j] = singleData.valueBrightness[j];
                      alarmLed[j] = singleData.alarmLed[j].map((element)=>element).toList();
                    }
                  }
                }
              if (singleData.statusFan != null)
                {
                  for (int j=0; j < singleData.statusFan.length; j++)
                  {
                    if (j < (statusFan.length))
                    {
                      alarmFan[j] = singleData.alarmFan[j].map((element)=>element).toList();
                      statusFan[j] = singleData.statusFan[j];
                    }
                  }
                }
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  connectServer() async
  {
   // singleData.socket = await Socket.connect(Constants.IP, Constants.PORT,timeout: Duration (seconds: 5));
 //   socket= await Socket.connect(Constants.IP, Constants.PORT,timeout: Duration (seconds: 5));
  }
  @override
  void initState() {
    super.initState();
    print("MAIN_VIEW ${singleData.socket}");
    connectServer();
    startTimer();
  }
  @override
  void dispose() {
    socket.close();
    _timer.cancel();
    super.dispose();
  }
//  RefreshController _refreshController =
//  RefreshController(initialRefresh: false);

//  void _onRefresh() async{
//    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use refreshFailed()
//    _refreshController.refreshCompleted();
//  }

  @override
  Widget build(BuildContext context) {
    
//    return new SmartRefresher(
//      enablePullDown: true,
//      //  enablePullUp: true,
//      controller: _refreshController,
//      onRefresh: _onRefresh,
//
//      child: new Container(
//        padding: new EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
//        color: Colors.lightGreen,
//
//        child: Column(
//          children: <Widget>[
//            Expanded(
//              flex: 3,
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  SizedBox(
//                                    height : 32,
//                                    width : 160,
//                                    child: Image.asset('image/hydro-32.png'),
//                                  ),
//
//                                  Text( 'Hydroponic',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 17.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//
//                  Expanded(
//                    flex: 1,
//                    child: Text(""),
//                  ),
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Image.asset('image/temperature-32.png'),
//                            ],
//                          ),
//                          SizedBox( width: 15,),
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  Text("Temperature",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 14.0)),
//                                  SizedBox( height: 5,),
//                                  Text( temperature +'°C',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 20.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//
//                ],
//              ),
//            ),
//
//            SizedBox(height: 2,),
//            Expanded(
//              flex: 3,
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Image.asset('image/rain-32.png'),
//                            ],
//                          ),
//                          SizedBox( width: 15,),
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  Text("Humidity",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 14.0)),
//                                  SizedBox( height: 5,),
//                                  Text(humidity + '%',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 20.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//
//                  Expanded(
//                    flex: 1,
//                    child: Text(""),
//                  ),
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Image.asset('image/ph-32.png'),
//                            ],
//                          ),
//                          SizedBox( width: 15,),
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  Text("PH",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 14.0)),
//                                  SizedBox( height: 5,),
//                                  Text(pH,
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 20.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(height: 2,),
//            Expanded(
//              flex: 3,
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Image.asset('image/water-32.png'),
//                            ],
//                          ),
//                          SizedBox( width: 15,),
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  Text("Water Level",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 14.0)),
//                                  SizedBox( height: 5,),
//                                  Text( waterLevel +'%',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 20.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                    flex: 1,
//                    child: Text(""),
//                  ),
//                  Expanded(
//                    flex: 17,
//                    child: Container(
//                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, color: Colors.grey),
//                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                          color: Colors.white),
//                      child: Row(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Image.asset('image/jacuzzi-32.png'),
//                            ],
//                          ),
//                          SizedBox( width: 15,),
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  Text("TDS",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 14.0)),
//                                  SizedBox( height: 5,),
//                                  Text(tds + "ppm",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 20.0)),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//
//
//                ],
//              ),
//            ),
//
//            SizedBox(height: 2,),
//            Expanded(
//              flex: 4,
//              child: Container(
//                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
//                decoration: BoxDecoration(
//                    border: Border.all(width: 0.5, color: Colors.grey),
//                    borderRadius:const BorderRadius.all(const Radius.circular(8.0)),  // boxShadow: [
//                    color: Colors.white),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        Expanded(
//                          flex: 17,
//                          child: Container(
//                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                // =====================================> FAN 1 <=====================================
//                                Expanded(
//                                  flex: 4,
//                                  child: SizedBox(
//                                    width: 32,
//                                    height: 32,
//                                    child: Image.asset('image/fan-32.png'),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    width: 32,
//                                    child: Text("Fan1",
//                                        style: TextStyle(
//                                            fontFamily: 'Montserrat',
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 15.0)),
//                                 //   child: Image.asset('image/fan-32.png'),
//                                  ),
//
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    child: ButtonTheme(
//                                      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                      child: MaterialButton(
//                                        color: Color(0xFF70B45A),
//                                        minWidth: 20.0,
//                                        height: 25.0,
//                                        onPressed: () {
//                                          setState(() {
//                                            if (singleData.statusApp)
//                                              {
//                                                String a= "0";
//                                                if(statusFan[0]==Constants.STATUS_ON)
//                                                {
//                                                  statusFan[0]=Constants.STATUS_OFF;
//                                                  a = Constants.VALUE_OFF;
//                                                }
//                                                else{
//                                                  statusFan[0]=Constants.STATUS_ON;
//                                                  a = Constants.VALUE_ON;
//                                                }
//                                                singleData.socket.add(utf8.encode('F1' + '|'+ a+'|@'));
//                                              }
//                                          });
//                                        },
//                                        child: Text(statusFan[0],
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                fontFamily: 'Montserrat',
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w500,
//                                                fontSize: 10.0)),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 6,
//                                  child: SizedBox(
//                                      width: 10,
//                                      child: IconButton(
//                                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
//                                          icon: Icon(Icons.alarm),
//                                          color: Color(0xFF70B45A),
//                                          onPressed: () {
//                                            if (singleData.statusApp)
//                                              {
//                                                singleData.size = Constants.SIZE_HEAD_FAN;
//                                                singleData.strAlarm = singleData.alarmFan[0].map((element)=>element).toList();
//
//                                                singleData.indexlist = 0;
//                                                singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
//                                                singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
//                                                goToPageAlarm(context);
//                                              }
//                                          }
//                                      )
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: SizedBox(width: 10,),
//                        ),
//                        // =====================================> FAN 2 <=====================================
//                        Expanded(
//                          flex: 17,
//                          child: Container(
//                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Expanded(
//                                  flex: 4,
//                                  child: SizedBox(
//                                    width: 32,
//                                    height: 32,
//                                    child: Image.asset('image/fan-32.png'),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    width: 32,
//                                    child: Text("Fan2",
//                                        style: TextStyle(
//                                            fontFamily: 'Montserrat',
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 15.0)),
//                                  ),
//
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    child: ButtonTheme(
//                                      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                      child: MaterialButton(
//                                        color: Color(0xFF70B45A),
//                                        minWidth: 20.0,
//                                        height: 25.0,
//                                        onPressed: () {
//                                          setState(() {
//                                            if (singleData.statusApp)
//                                            {
//                                              String a= "0";
//                                              if(statusFan[1]==Constants.STATUS_ON)
//                                              {
//                                                statusFan[1]=Constants.STATUS_OFF;
//                                                a = Constants.VALUE_OFF;
//                                              }
//                                              else{
//                                                statusFan[1]=Constants.STATUS_ON;
//                                                a = Constants.VALUE_ON;
//                                              }
//                                              singleData.socket.add(utf8.encode('F2|'+ a+'|@'));
//                                            }
//                                          });
//
//                                        },
//                                        child: Text(statusFan[1],
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                fontFamily: 'Montserrat',
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w500,
//                                                fontSize: 10.0)),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 6,
//                                  child: SizedBox(
//                                      width: 10,
//                                      child: IconButton(
//                                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
//                                          icon: Icon(Icons.access_alarm),
//                                          color: Color(0xFF70B45A),
//                                          onPressed: () {
//                                            if (singleData.statusApp)
//                                              {
//                                                singleData.size = Constants.SIZE_HEAD_FAN;
//                                                singleData.strAlarm = singleData.alarmFan[1].map((element)=>element).toList();
//                                                singleData.indexlist = 1;
//                                                singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
//                                                singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
//                                                goToPageAlarm(context);
//                                              }
//                                          }
//                                      )
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//
//                      ],
//                    ),
//                   // SizedBox(height: 5,),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        // =====================================> FAN 3 <=====================================
//                        Expanded(
//                          flex: 17,
//                          child: Container(
//                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Expanded(
//                                  flex: 4,
//                                  child: SizedBox(
//                                    width: 32,
//                                    height: 32,
//                                    child: Image.asset('image/fan-32.png'),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    width: 32,
//                                    child: Text("Fan3",
//                                        style: TextStyle(
//                                            fontFamily: 'Montserrat',
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 15.0)),
//                                  ),
//
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    child: ButtonTheme(
//                                      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                      child: MaterialButton(
//                                        color: Color(0xFF70B45A),
//                                        minWidth: 20.0,
//                                        height: 25.0,
//                                        onPressed: () {
//                                          setState(() {
//                                            if (singleData.statusApp)
//                                              {
//                                                String a= "0";
//                                                if(statusFan[2]==Constants.STATUS_ON)
//                                                {
//                                                  statusFan[2]=Constants.STATUS_OFF;
//                                                  a = Constants.VALUE_OFF;
//                                                }
//                                                else{
//                                                  statusFan[2]=Constants.STATUS_ON;
//                                                  a = Constants.VALUE_ON;
//                                                }
//                                                singleData.socket.add(utf8.encode('F3|'+ a+'|@'));
//                                              }
//                                          });
//                                        },
//                                        child: Text(statusFan[2],
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                fontFamily: 'Montserrat',
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w500,
//                                                fontSize: 10.0)),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 6,
//                                  child: SizedBox(
//                                      width: 10,
//                                      child: IconButton(
//                                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
//                                          icon: Icon(Icons.access_alarm),
//                                          color: Color(0xFF70B45A),
//                                          onPressed: () {
//                                            if (singleData.statusApp)
//                                              {
//                                                singleData.size = Constants.SIZE_HEAD_FAN;
//                                                singleData.strAlarm = singleData.alarmFan[2].map((element)=>element).toList();
//                                                singleData.indexlist = 2;
//                                                singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
//                                                singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
//                                                goToPageAlarm(context);
//                                              }
//                                          }
//                                      )
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: SizedBox(height: 10,),
//                        ),
//                        // =====================================> FAN 4 <=====================================
//                        Expanded(
//                          flex: 17,
//                          child: Container(
//                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Expanded(
//                                  flex: 4,
//                                  child: SizedBox(
//                                    width: 32,
//                                    height: 32,
//                                    child: Image.asset('image/fan-32.png'),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    width: 32,
//                                    child: Text("Fan4",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 15.0)),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 5,
//                                  child: SizedBox(
//                                    child: ButtonTheme(
//                                      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                      child: MaterialButton(
//                                        color: Color(0xFF70B45A),
//                                        minWidth: 20.0,
//                                        height: 25.0,
//                                        onPressed: () {
//                                          setState(() {
//                                            if (singleData.statusApp)
//                                              {
//                                                String a= "0";
//                                                if(statusFan[3]==Constants.STATUS_ON)
//                                                {
//                                                  statusFan[3]=Constants.STATUS_OFF;
//                                                  a = Constants.VALUE_OFF;
//                                                }
//                                                else{
//                                                  statusFan[3]=Constants.STATUS_ON;
//                                                  a = Constants.VALUE_ON;
//                                                }
//                                                singleData.socket.add(utf8.encode('F4|'+ a+'|@'));
//                                              }
//                                          });
//                                        },
//                                        child: Text(statusFan[3],
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                fontFamily: 'Montserrat',
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w500,
//                                                fontSize: 10.0)),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 6,
//                                  child: SizedBox(
//                                      width: 10,
//                                      child: IconButton(
//                                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
//                                          icon: Icon(Icons.access_alarm),
//                                          color: Color(0xFF70B45A),
//                                          onPressed: () {
//                                            if (singleData.statusApp)
//                                              {
//                                                singleData.size = Constants.SIZE_HEAD_FAN;
//                                                singleData.strAlarm = singleData.alarmFan[3].map((element)=>element).toList();
//                                                singleData.indexlist = 3;
//                                                singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
//                                                singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
//                                                goToPageAlarm(context);
//                                              }
//                                          }
//                                      )
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//
//            SizedBox(height: 2,),
//            // ===========================> giao dien phan dieu khien den CONTROLLED<===========================
//            Expanded(
//              flex: 9,
//            child: Container(
//              padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 0.0, right: 5.0),
//              decoration: BoxDecoration(
//                  border: Border.all(width: 0.5, color: Colors.grey),
//                  borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                  color: Colors.white),
//              child: Column(
//                children: <Widget>[
//                  // =============================> LED 1 <===============================
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 32,
//                                  height: 32,
//                                  child: Image.asset('image/light-32.png'),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text("Led1",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 15.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 7,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Slider(
//                                    activeColor: Colors.lightGreen,
//                                    min: 0.0,
//                                    max: 100.0,
//                                    onChanged: (newRating) {
//                                      setState(() {
//                                        if (singleData.statusApp)
//                                          {
//                                            brightness[0] = newRating.round().toDouble() ;
//                                            singleData.socket.add(utf8.encode('BR1|'+ brightness[0].toString()+'|@'));
//                                          }
//                                      });
//                                    },
//                                    value: brightness[0],
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text('${brightness[0].round()}',style: TextStyle(
//                                      fontFamily: 'Montserrat',
//                                      color: Colors.black,
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 11.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//
//                                child: SizedBox(
//                                  child: ButtonTheme(
//                                    padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                    child: MaterialButton(
//                                      color: Color(0xFF70B45A),
//                                      minWidth: 20.0,
//                                      height: 25.0,
//                                      onPressed: () {
//                                        setState(() {
//                                          if (singleData.statusApp)
//                                          {
//                                            String a= "0";
//                                            if(statusLed[0]==Constants.STATUS_ON)
//                                            {
//                                              statusLed[0]=Constants.STATUS_OFF;
//                                              a = Constants.VALUE_OFF;
//                                            }
//                                            else{
//                                              statusLed[0]=Constants.STATUS_ON;
//                                              a = Constants.VALUE_ON;
//                                            }
//                                            singleData.socket.add(utf8.encode('D1|'+ a+'|@'));
//                                          }
//                                        });
//                                      },
//                                      child: Text(statusLed[0],
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontFamily: 'Montserrat',
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.w500,
//                                              fontSize: 10.0)),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                    width: 10,
//                                    child: IconButton(
//                                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
//                                        icon: Icon(Icons.access_alarm),
//                                        color: Color(0xFF70B45A),
//                                        onPressed: () {
//                                          if (singleData.statusApp)
//                                            {
//                                              singleData.size = Constants.SIZE_HEAD_LED;
//                                              singleData.strAlarm = singleData.alarmLed[0].map((element)=>element).toList();
//                                              singleData.indexlist = 0;
//                                              singleData.headerAlarm = Constants.HEAD_ALARM_LED;
//                                              singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
//                                              goToPageAlarm(context);
//                                            }
//                                        }
//                                    )
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
////                  SizedBox(
////                    height: 5,
////                  ),
//                  // =============================> LED 2 <===============================
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 32,
//                                  height: 32,
//                                  child: Image.asset('image/light-32.png'),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text("Led2",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 15.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 7,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Slider(
//                                    activeColor: Colors.lightGreen,
//                                    min: 0.0,
//                                    max: 100.0,
//                                    onChanged: (newRating) {
//                                      setState(() {
//                                        if (singleData.statusApp)
//                                        {
//                                          brightness[1] = newRating.round().toDouble() ;
//                                          singleData.socket.add(utf8.encode('BR2|'+ brightness[1].toString()+'|@'));
//                                        }
//                                      });
//                                    },
//                                    value: brightness[1],
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text('${brightness[1].round()}',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 11.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//
//                                child: SizedBox(
//                                  child: ButtonTheme(
//                                    padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                    child: MaterialButton(
//                                      color: Color(0xFF70B45A),
//                                      minWidth: 20.0,
//                                      height: 25.0,
//                                      onPressed: () {
//                                        setState(() {
//                                          if (singleData.statusApp)
//                                            {
//                                              String a= "0";
//                                              if(statusLed[1]==Constants.STATUS_ON)
//                                              {
//                                                statusLed[1]=Constants.STATUS_OFF;
//                                                a = Constants.VALUE_OFF;
//                                              }
//                                              else{
//                                                statusLed[1]=Constants.STATUS_ON;
//                                                a = Constants.VALUE_ON;
//                                              }
//                                              singleData.socket.add(utf8.encode('D2|'+ a+'|@'));
//                                            }
//                                        });
//                                      },
//                                      child: Text(statusLed[1],
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontFamily: 'Montserrat',
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.w500,
//                                              fontSize: 10.0)),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                    width: 10,
//                                    child: IconButton(
//                                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
//                                        icon: Icon(Icons.access_alarm),
//                                        color: Color(0xFF70B45A),
//                                        onPressed: () {
//                                          if (singleData.statusApp)
//                                            {
//                                              singleData.size = Constants.SIZE_HEAD_LED;
//                                              singleData.strAlarm = singleData.alarmLed[1].map((element)=>element).toList();
//                                              singleData.indexlist = 1;
//                                              singleData.headerAlarm = Constants.HEAD_ALARM_LED;
//                                              singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
//                                              goToPageAlarm(context);
//                                            }
//                                        }
//                                    )
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
////                  SizedBox(
////                    height: 5,
////                  ),
//                  // =============================> LED 3 <===============================
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 32,
//                                  height: 32,
//                                  child: Image.asset('image/light-32.png'),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text("Led3",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 15.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 7,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Slider(
//                                    activeColor: Colors.lightGreen,
//                                    min: 0.0,
//                                    max: 100.0,
//                                    onChanged: (newRating) {
//                                      setState(() {
//                                        if (singleData.statusApp)
//                                          {
//                                            brightness[2] = newRating.round().toDouble() ;
//                                            singleData.socket.add(utf8.encode('BR3|'+ brightness[2].toString()+'|@'));
//                                          }
//                                      });
//                                    },
//                                    value: brightness[2],
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text('${(brightness[2]).round()}',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 11.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//
//                                child: SizedBox(
//                                  child: ButtonTheme(
//                                    padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                    child: MaterialButton(
//                                      color: Color(0xFF70B45A),
//                                      minWidth: 20.0,
//                                      height: 25.0,
//                                      onPressed: () {
//                                        setState(() {
//                                          if (singleData.statusApp)
//                                            {
//                                              String a= "0";
//                                              if(statusLed[3]==Constants.STATUS_ON)
//                                              {
//                                                statusLed[3]=Constants.STATUS_OFF;
//                                                a = Constants.VALUE_OFF;
//                                              }
//                                              else{
//                                                statusLed[3]=Constants.STATUS_ON;
//                                                a = Constants.VALUE_ON;
//                                              }
//                                              singleData.socket.add(utf8.encode('D3|'+ a+'|@'));
//                                            }
//                                        });
//                                      },
//                                      child: Text(statusLed[2],
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontFamily: 'Montserrat',
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.w500,
//                                              fontSize: 10.0)),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                    width: 10,
//                                    child: IconButton(
//                                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
//                                        icon: Icon(Icons.access_alarm),
//                                        color: Color(0xFF70B45A),
//                                        onPressed: () {
//                                          if (singleData.statusApp)
//                                            {
//                                              singleData.size = Constants.SIZE_HEAD_LED;
//                                              singleData.strAlarm = singleData.alarmLed[2].map((element)=>element).toList();
//                                              singleData.indexlist = 2;
//                                              singleData.headerAlarm = Constants.HEAD_ALARM_LED;
//                                              singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
//                                              goToPageAlarm(context);
//                                            }
//                                        }
//                                    )
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
////                  SizedBox(
////                    height: 5,
////                  ),
//                  // =============================> LED 4 <===============================
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 32,
//                                  height: 32,
//                                  child: Image.asset('image/light-32.png'),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text("Led4",
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 15.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 7,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Slider(
//                                    activeColor: Colors.lightGreen,
//                                    min: 0.0,
//                                    max: 100.0,
//                                    onChanged: (newRating) {
//                                      setState(() {
//                                        if (singleData.statusApp)
//                                          {
//                                            brightness[3] = newRating.round().toDouble() ;
//                                            singleData.socket.add(utf8.encode('BR4|'+ brightness[3].toString()+'|@'));
//                                          }
//                                      });
//                                    },
//                                    value: brightness[3],
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text('${(brightness[3]).round()}',
//                                      style: TextStyle(
//                                          fontFamily: 'Montserrat',
//                                          color: Colors.black,
//                                          fontWeight: FontWeight.w500,
//                                          fontSize: 11.0)),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//
//                                child: SizedBox(
//                                  child: ButtonTheme(
//                                    padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                    child: MaterialButton(
//                                      color: Color(0xFF70B45A),
//                                      minWidth: 20.0,
//                                      height: 25.0,
//                                      onPressed: () {
//                                        setState(() {
//                                          if (singleData.statusApp)
//                                            {
//                                              String a= "0";
//                                              if(statusLed[3]==Constants.STATUS_ON)
//                                              {
//                                                statusLed[3]=Constants.STATUS_OFF;
//                                                a = Constants.VALUE_OFF;
//                                              }
//                                              else{
//                                                statusLed[3]=Constants.STATUS_ON;
//                                                a = Constants.VALUE_ON;
//                                              }
//                                              singleData.socket.add(utf8.encode('D4|'+ a+'|@'));
//                                            }
//                                        });
//                                      },
//                                      child: Text(statusLed[3],
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontFamily: 'Montserrat',
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.w500,
//                                              fontSize: 10.0)),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: SizedBox(
//                                    width: 10,
//                                    child: IconButton(
//                                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
//                                        icon: Icon(Icons.access_alarm),
//                                        color: Color(0xFF70B45A),
//                                        onPressed: () {
//                                          if (singleData.statusApp)
//                                            {
//                                              singleData.size = Constants.SIZE_HEAD_LED;
//                                              singleData.strAlarm = singleData.alarmLed[3].map((element)=>element).toList();
//                                              singleData.indexlist = 3;
//                                              singleData.headerAlarm = Constants.HEAD_ALARM_LED;
//                                              singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
//                                              goToPageAlarm(context);
//                                            }
//                                        }
//                                    )
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//            ),
//
//            SizedBox(height: 2,),
//            // ===========================> GIAO DIEN DIEU KHIEN MAY BOM <============================
//            Expanded(
//              flex: 2,
//              child: Container(
//                padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 5.0, right: 5.0),
//                decoration: BoxDecoration(
//                    border: Border.all(width: 0.5, color: Colors.grey),
//                    borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
//                    color: Colors.white),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      flex: 9,
//                      child: Container(
//                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Expanded(
//                              flex: 3,
//                              child: SizedBox(
//                                width: 32,
//                                height: 32,
//                                child: Image.asset('image/pump-32.png'),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 15,
//                              child: SizedBox(
//                                width: 32,
//                                child: Text("Pump",
//                                    style: TextStyle(
//                                        fontFamily: 'Montserrat',
//                                        color: Colors.black,
//                                        fontWeight: FontWeight.w500,
//                                        fontSize: 15.0)),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 3,
//                              child: SizedBox(
//                                child: ButtonTheme(
//                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
//                                  child: MaterialButton(
//                                    color: Color(0xFF70B45A),
//                                    minWidth: 20.0,
//                                    height: 25.0,
//                                    onPressed: () {
//                                      setState(() {
//                                      });
//
//                                    },
//                                    child: Text(statusPUMP,
//                                        textAlign: TextAlign.center,
//                                        style: TextStyle(
//                                            fontFamily: 'Montserrat',
//                                            color: Colors.white,
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 10.0)),
//                                  ),
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 3,
//                              child: Text(""),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//
//            // ===========================> BUTTON APPLY <=====================
////            Expanded(
////              flex: 2,
////              child: Column(
////                mainAxisAlignment: MainAxisAlignment.end,
////                crossAxisAlignment: CrossAxisAlignment.center,
////                mainAxisSize: MainAxisSize.max,
////                children: <Widget>[
////
////                  ButtonTheme(
////                    child: MaterialButton(
////                      color: Colors.white,
////                      minWidth: 100.0,
////                      height: 30.0,
////                      shape: new RoundedRectangleBorder(
////                        borderRadius: new BorderRadius.circular(3.0),
////                      ),
////                      onPressed: () {
////                      },
////                      child: Text("APPLY",
////                          textAlign: TextAlign.center,
////
////                          style: TextStyle(
////                              fontFamily: 'Montserrat',
////                              color: Colors.black,
////                              fontWeight: FontWeight.w500,
////                              fontSize: 15.0)),
////                    ),
////                  ),
////                ],
////              ),
////            )
//          ],
//        ),
//      ),
//
//    );

      return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(top: 10.0, bottom: 15.0, left: 5.0, right: 5.0),
              color: Colors.lightGreen,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height : 32,
                                          width : 140,
                                          child: Image.asset('image/hydro-32.png'),
                                        ),

                                        Text( singleData.testrunapp,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 0.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset('image/temperature-32.png'),
                                  ],
                                ),
                                SizedBox( width: 15,),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("Temperature",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0)),
                                        SizedBox( height: 10,),
                                        Text( temperature +'°C',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset('image/rain-32.png'),
                                  ],
                                ),
                                SizedBox( width: 15,),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("Humidity",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0)),
                                        SizedBox( height: 5,),
                                        Text(humidity + '%',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset('image/ph-32.png'),
                                  ],
                                ),
                                SizedBox( width: 15,),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("PH",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0)),
                                        SizedBox( height: 5,),
                                        Text(pH,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset('image/water-32.png'),
                                  ],
                                ),
                                SizedBox( width: 15,),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("Water Level",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0)),
                                        SizedBox( height: 5,),
                                        Text( waterLevel +'%',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 17,
                          child: Container(
                            padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                                color: Colors.white),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset('image/jacuzzi-32.png'),
                                  ],
                                ),
                                SizedBox( width: 15,),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("TDS",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0)),
                                        SizedBox( height: 5,),
                                        Text(tds + "ppm",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    child: Container(
                      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),  // boxShadow: [
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 17,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      // =====================================> FAN 1 <=====================================
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/fan-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          width: 32,
                                          child: Text("Fan1",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                          //   child: Image.asset('image/fan-32.png'),
                                        ),

                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusFan[0]==Constants.STATUS_ON)
                                                    {
                                                      statusFan[0]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusFan[0]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('F1' + '|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusFan[0],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
                                                icon: Icon(Icons.alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_FAN;
                                                    singleData.strAlarm = singleData.alarmFan[0].map((element)=>element).toList();

                                                    singleData.indexlist = 0;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
                                                    singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(width: 10,),
                              ),
                              // =====================================> FAN 2 <=====================================
                              Expanded(
                                flex: 17,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/fan-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          width: 32,
                                          child: Text("Fan2",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),

                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusFan[1]==Constants.STATUS_ON)
                                                    {
                                                      statusFan[1]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusFan[1]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('F2|'+ a+'|@'));
                                                  }
                                                });

                                              },
                                              child: Text(statusFan[1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_FAN;
                                                    singleData.strAlarm = singleData.alarmFan[1].map((element)=>element).toList();
                                                    singleData.indexlist = 1;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
                                                    singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          // SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // =====================================> FAN 3 <=====================================
                              Expanded(
                                flex: 17,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/fan-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          width: 32,
                                          child: Text("Fan3",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),

                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusFan[2]==Constants.STATUS_ON)
                                                    {
                                                      statusFan[2]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusFan[2]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('F3|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusFan[2],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_FAN;
                                                    singleData.strAlarm = singleData.alarmFan[2].map((element)=>element).toList();
                                                    singleData.indexlist = 2;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
                                                    singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(height: 10,),
                              ),
                              // =====================================> FAN 4 <=====================================
                              Expanded(
                                flex: 17,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/fan-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          width: 32,
                                          child: Text("Fan4",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusFan[3]==Constants.STATUS_ON)
                                                    {
                                                      statusFan[3]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusFan[3]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('F4|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusFan[3],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_FAN;
                                                    singleData.strAlarm = singleData.alarmFan[3].map((element)=>element).toList();
                                                    singleData.indexlist = 3;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_FAN;
                                                    singleData.statusAlarm = singleData.statusFan.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    child: Container(
                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 0.0, right: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          // =============================> LED 1 <===============================
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/light-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text("Led1",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: SizedBox(
                                          width: 18,
                                          child: Slider(
                                            activeColor: Colors.lightGreen,
                                            min: 0.0,
                                            max: 100.0,
                                            onChanged:(newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  brightness[0] = newRating.round().toDouble() ;
                                                }
                                              });
                                            },
                                            onChangeEnd: (newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  singleData.socket.add(utf8.encode('BR1|'+ brightness[0].toString()+'|@'));
                                                }
                                              });
                                            },
                                            value: brightness[0],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text('${brightness[0].round()}',style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,

                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusLed[0]==Constants.STATUS_ON)
                                                    {
                                                      statusLed[0]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusLed[0]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('D1|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusLed[0],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_LED;
                                                    singleData.strAlarm = singleData.alarmLed[0].map((element)=>element).toList();
                                                    singleData.indexlist = 0;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_LED;
                                                    singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
//                  SizedBox(
//                    height: 5,
//                  ),
                          // =============================> LED 2 <===============================
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/light-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text("Led2",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: SizedBox(
                                          width: 18,
                                          child: Slider(
                                            activeColor: Colors.lightGreen,
                                            min: 0.0,
                                            max: 100.0,
                                            onChanged: (newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  brightness[1] = newRating.round().toDouble() ;
                                                }
                                              });
                                            },
                                            onChangeEnd: (newRating){
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  singleData.socket.add(utf8.encode('BR2|'+ brightness[1].toString()+'|@'));
                                                }
                                              });
                                            },
                                            value: brightness[1],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text('${brightness[1].round()}',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,

                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusLed[1]==Constants.STATUS_ON)
                                                    {
                                                      statusLed[1]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusLed[1]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('D2|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusLed[1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_LED;
                                                    singleData.strAlarm = singleData.alarmLed[1].map((element)=>element).toList();
                                                    singleData.indexlist = 1;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_LED;
                                                    singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
//                  SizedBox(
//                    height: 5,
//                  ),
                          // =============================> LED 3 <===============================
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/light-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text("Led3",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: SizedBox(
                                          width: 18,
                                          child: Slider(
                                            activeColor: Colors.lightGreen,
                                            min: 0.0,
                                            max: 100.0,
                                            onChanged: (newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  brightness[2] = newRating.round().toDouble() ;
                                                }
                                              });
                                            },
                                            onChangeEnd: (newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  singleData.socket.add(utf8.encode('BR3|'+ brightness[2].toString()+'|@'));
                                                }
                                              });
                                            },
                                            value: brightness[2],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text('${(brightness[2]).round()}',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,

                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusLed[3]==Constants.STATUS_ON)
                                                    {
                                                      statusLed[3]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusLed[3]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('D3|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusLed[2],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_LED;
                                                    singleData.strAlarm = singleData.alarmLed[2].map((element)=>element).toList();
                                                    singleData.indexlist = 2;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_LED;
                                                    singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
//                  SizedBox(
//                    height: 5,
//                  ),
                          // =============================> LED 4 <===============================
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Image.asset('image/light-32.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text("Led4",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: SizedBox(
                                          width: 18,
                                          child: Slider(
                                            activeColor: Colors.lightGreen,
                                            min: 0.0,
                                            max: 100.0,
                                            onChanged: (newRating) {
                                            setState(() {
                                              if (singleData.statusApp)
                                              {
                                                brightness[3] = newRating.round().toDouble() ;
                                              }
                                            });
                                          },
                                            onChangeEnd: (newRating) {
                                              setState(() {
                                                if (singleData.statusApp)
                                                {
                                                  singleData.socket.add(utf8.encode('BR4|'+ brightness[3].toString()+'|@'));
                                                }
                                              });
                                            },
                                            value: brightness[3],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 18,
                                          child: Text('${(brightness[3]).round()}',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.0)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,

                                        child: SizedBox(
                                          child: ButtonTheme(
                                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                            child: MaterialButton(
                                              color: Color(0xFF70B45A),
                                              minWidth: 20.0,
                                              height: 25.0,
                                              onPressed: () {
                                                setState(() {
                                                  if (singleData.statusApp)
                                                  {
                                                    String a= "0";
                                                    if(statusLed[3]==Constants.STATUS_ON)
                                                    {
                                                      statusLed[3]=Constants.STATUS_OFF;
                                                      a = Constants.VALUE_OFF;
                                                    }
                                                    else{
                                                      statusLed[3]=Constants.STATUS_ON;
                                                      a = Constants.VALUE_ON;
                                                    }
                                                    singleData.socket.add(utf8.encode('D4|'+ a+'|@'));
                                                  }
                                                });
                                              },
                                              child: Text(statusLed[3],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                            width: 10,
                                            child: IconButton(
                                                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
                                                icon: Icon(Icons.access_alarm),
                                                color: Color(0xFF70B45A),
                                                onPressed: () {
                                                  if (singleData.statusApp)
                                                  {
                                                    singleData.size = Constants.SIZE_HEAD_LED;
                                                    singleData.strAlarm = singleData.alarmLed[3].map((element)=>element).toList();
                                                    singleData.indexlist = 3;
                                                    singleData.headerAlarm = Constants.HEAD_ALARM_LED;
                                                    singleData.statusAlarm = singleData.statusLed.map((element)=>element).toList();
                                                    goToPageAlarm(context);
                                                  }
                                                }
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    child: Container(
                      padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, left: 5.0, right: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                          color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 9,
                            child: Container(
                              padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset('image/pump-32.png'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: SizedBox(
                                      width: 32,
                                      child: Text("Pump",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      child: ButtonTheme(
                                        padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                                        child: MaterialButton(
                                          color: Color(0xFF70B45A),
                                          minWidth: 20.0,
                                          height: 25.0,
                                          onPressed: () {
                                            setState(() {
                                            });

                                          },
                                          child: Text(statusPUMP,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(""),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  }
}
Future goToPageAlarm(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AlarmView()));
}