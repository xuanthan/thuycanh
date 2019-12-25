import 'package:flutter/material.dart';
import 'package:thuycanh_app/singleton_data.dart';
import 'singleton_data.dart';
import 'constants.dart';
import 'dart:async';
import 'dart:convert';
import 'alarm_view.dart';

class FanView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BodyFanWidget(),
    );
  }
}

class BodyFanWidget extends StatefulWidget {
  @override
  _BodyFanWidgetState createState() => _BodyFanWidgetState();
}

class _BodyFanWidgetState extends State<BodyFanWidget> {
  var singledata = Singleton.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      print(" check length Fan   ${singledata.lengthFan}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Expanded(child: new ListView.builder(itemCount: singledata.lengthFan,
              itemBuilder: (context, index) => this._buildRow(index)),),
        ],
      ),
    );
  }

  _buildRow(int index) {
    return Container(
      padding: new EdgeInsets.only(top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 0.75, color: Colors.lightGreen),
          borderRadius:const BorderRadius.all(const Radius.circular(3.0)),
          color: Colors.white),
      child: Row(
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
                    flex: 3,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset('image/fan-32.png'),
                    ),
                  ),
                  Expanded(
                    flex:2 ,
                    child: Text(""),
                  ),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      width: 32,
                      child: Text("Fan"+ (index + 1).toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0)),
                      //   child: Image.asset('image/fan-32.png'),
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
                          //    singledata.statusFan[index]==Constants.STATUS_ON?singledata.statusFan[index]=Constants.STATUS_OFF:singledata.statusFan[index]=Constants.STATUS_ON;ocket.add(utf8.encode('D4|'+ a+'|@'));
                              if (singledata.statusApp)
                                {
                                  String a = "0";
                                  if(singledata.statusFan[index]==Constants.STATUS_ON)
                                  {
                                    singledata.statusFan[index]=Constants.STATUS_OFF;
                                    a = Constants.VALUE_OFF;
                                  }
                                  else{
                                    singledata.statusFan[index]=Constants.STATUS_ON;
                                    a = Constants.VALUE_ON;
                                  }
                                  singledata.alarmFan[index][1] = a;
                                  print("Send Fan ${singledata.alarmFan[index]}");
                                  String b = _convertToString(singledata.alarmFan[index]);

                                  singledata.socket.add(utf8.encode('F' + (index +1).toString() + '|'+ b+'|@'));
                                }
                            });
                          },
                          child: Text(singledata.statusFan[index],
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
                    flex:1 ,
                    child: Text(""),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                        width: 10,
                        child: IconButton(
                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0),
                            icon: Icon(Icons.alarm),
                            color: Color(0xFF70B45A),
                            onPressed: () {
                              singledata.size = Constants.SIZE_HEAD_FAN;
                              singledata.strAlarm = singledata.alarmFan[index].map((element)=>element).toList();
                              singledata.indexlist = index;
                              singledata.headerAlarm = Constants.HEAD_ALARM_FAN;
                              singledata.statusAlarm = singledata.statusFan.map((element)=>element).toList();
                              goToPageAlarm(context);
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
    );
  }
}
Future goToPageAlarm(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AlarmView()));
}
String _convertToString(List<String> list)
{
  String _str= "";
  for (int i = 0; i< list.length; i++)
  {
    if(list[i] != "")
      _str += list[i] + "|";
  }
  _str = _str + '@';
  print(_str);
  return _str;
}