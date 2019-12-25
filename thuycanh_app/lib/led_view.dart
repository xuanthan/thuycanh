import 'package:flutter/material.dart';
import 'singleton_data.dart';
import 'constants.dart';
import 'dart:async';
import 'dart:convert';
import 'alarm_view.dart';

class LedView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyLedWidget(),
    );
  }
}
class BodyLedWidget extends StatefulWidget {
  @override
  _BodyLedWidgetState createState() => _BodyLedWidgetState();
}

class _BodyLedWidgetState extends State<BodyLedWidget> {

  var singledata = Singleton.instance;
  getdata(){

  }
  @override
  void initState() {
    super.initState();
    getdata();
//    @override
//    void initState() {
//      super.initState();
//      setState(() {
//        print(" check length lengthLed   ${singledata.lengthLed}");
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Expanded(child: new ListView.builder(itemCount: singledata.lengthLed,
              itemBuilder: (context, index) => this._buildRow(index)),),
        ],
      ),
    );
  }

  _buildRow(int index) {
    return Container(
      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.75, color: Colors.lightGreen),
                  borderRadius:const BorderRadius.all(const Radius.circular(3.0)),
                  color: Colors.white),
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
                      child: Text("Led"+ (index + 1).toString(),
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
                          singledata.valueBrightness[index] = newRating.round().toDouble() ;
                          singledata.alarmLed[index][1] = singledata.valueBrightness[index].toString();
                      //    String a = _convertToString(singledata.alarmLed[index]);
                       //   singledata.socket.add(utf8.encode('BR' + (index +1).toString() + '|'+ a+'|@'));
                        });
                      },
                        onChangeEnd: (newRating) {
                          setState(() {
                         //   singledata.valueBrightness[index] = newRating.round().toDouble() ;
                          //  singledata.alarmLed[index][1] = singledata.valueBrightness[index].toString();
                            String a = _convertToString(singledata.alarmLed[index]);
                            singledata.socket.add(utf8.encode('BR' + (index +1).toString() + '|'+ a+'|@'));
                          });
                        },
                        value: singledata.valueBrightness[index],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 18,
                      child: Text('${singledata.valueBrightness[index].round()}',style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0)),
                    ),
                  ),
//                              Expanded(
//                                flex: 1,
//                                child: SizedBox(
//                                  width: 18,
//                                  child: Text(''),
//                                ),
//                              ),
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
                            //  singledata.statusLed[index]==Constants.STATUS_ON?singledata.statusLed[index]=Constants.STATUS_OFF:singledata.statusLed[index]=Constants.STATUS_ON;
                              if (singledata.statusApp)
                                {
                                  String a = "0";
                                  if(singledata.statusLed[index]==Constants.STATUS_ON)
                                  {
                                    singledata.statusLed[index]=Constants.STATUS_OFF;
                                    a = Constants.VALUE_OFF;
                                  }
                                  else{
                                    singledata.statusLed[index]=Constants.STATUS_ON;
                                    a = Constants.VALUE_ON;
                                  }
                                  singledata.alarmLed[index][2] = a;
                                  String b = _convertToString(singledata.alarmLed[index]);
                                  //    singledata.socket.add(utf8.encode('START@'));
                                  singledata.socket.add(utf8.encode('D' + (index +1).toString() + '|'+ b+'|@'));
                                }
                            });
                          },
                          child: Text(singledata.statusLed[index],
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
                              singledata.size = Constants.SIZE_HEAD_LED;
                              singledata.strAlarm = singledata.alarmLed[index].map((element)=>element).toList();
                              singledata.indexlist = index;
                              singledata.headerAlarm = Constants.HEAD_ALARM_LED;
                              singledata.statusAlarm = singledata.statusLed.map((element)=>element).toList();
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