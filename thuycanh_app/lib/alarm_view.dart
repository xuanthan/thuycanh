import 'package:flutter/material.dart';
import 'dart:async';
//import 'constants.dart';
import 'singleton_data.dart';
import 'dart:convert';
class AlarmView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
        backgroundColor: Colors.green[800],
      ),
      body: BodyAlarmView(),
    );

  }
//  _buildRow(int index) {
//    return Text("Item " + index.toString());
//  }
}
class BodyAlarmView extends StatefulWidget {
  @override
  _BodyAlarmViewState createState() => _BodyAlarmViewState();
}

class _BodyAlarmViewState extends State<BodyAlarmView> {

  TimeOfDay selectedTime =TimeOfDay.now();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedTime )
      setState(() {
        selectedTime = picked_s;
        _data.strAlarm.add(selectedTime.format(context));
        _data.strAlarm.add("1");
        _data.statusAlarm.add("ON");
        _addItem();
      });
  }

  int value = 2;
  var _data = Singleton.instance ;
  _addItem() {
    setState(() {
      value = value + 1;
    });
  }
  _deleteItem() {
    setState(() {
      value = value - 1;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(top: 0.0, bottom: 10.0, left: 5.0, right: 5.0),
      child: new Column(
        children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ButtonTheme(
                  child: MaterialButton(
                    color: Color(0xFF70B45A),
                    minWidth: 125.0,
                    height: 40.0,
                    onPressed:(){
                      print("strAlarm=${_data.strAlarm}");
                      String a = _convertToString1(_data.strAlarm, "|",_data.headerAlarm,_data.size,_data.indexlist);
                      _data.socket.add(utf8.encode(a));
                    } ,

                    child: Text("Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0)),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.black,
                  onPressed: (){
                    _selectTime(context);
                  },
                ),
              ),
            ],
          ),
        ),
          Container(
            padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.grey),
                borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    offset: Offset(2.0, 4.0),
                    blurRadius: 17.0,
                  ),
                ],
                color: Colors.white),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text("Time",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Text("",),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Status",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Text("",),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Delete",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500
                      )),
                ),
              ],
            ),
          ),
          Expanded(child: new ListView.builder(itemCount: (_data.strAlarm.length - _data.size)~/2,
              itemBuilder: (context, index) => this._buildRow(index)),),

        ],
      ),
    );
  }

  _buildRow(int index) {
   // String str ="";
   // _data.strAlarm[_data.size+index*2 + 1] =="1" ?str="ON":str="OFF";
    return Container(
      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius:const BorderRadius.all(const Radius.circular(8.0)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: Offset(2.0, 4.0),
              blurRadius: 17.0,
            ),
          ],
          color: Colors.white),
      child: Row(
        children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(_data.strAlarm[_data.size+index*2].toString(),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500
                  )),
            ),
          Expanded(
            flex: 3,
            child: Text("",),
          ),
          Expanded(
            flex: 1,
            child: Text("",),
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
                  //    str=="ON"?str="OFF":str="ON";
                      //?_data.statusAlarm[index]="OFF":_data.statusAlarm[index]="ON";
                      if(_data.statusAlarm[index]=="ON")
                        {
                        _data.strAlarm[index*2 +_data.size + 1] = "0";
                        _data.statusAlarm[index]="OFF";
                        }
                      else
                        {
                          _data.strAlarm[index*2 +_data.size + 1] = "1";
                          _data.statusAlarm[index]="ON";
                        }
                    });
                  },
                  child: Text('${_data.statusAlarm[index]}',
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
            flex: 5,
            child: Text("",),
          ),
          Expanded(
            flex: 3,
            child: IconButton(
              icon: Icon(Icons.delete),
              color: Color(0xFF70B45A),
              onPressed: (){
                _data.strAlarm.removeRange(_data.size+index*2,_data.size+index*2 +2);
                _data.statusAlarm.removeAt(index);
                _deleteItem();
              },
            )
          ),
        ],
      ),
    );
  }
}
String _convertToString1(List<String> list , String _div, String _header, int _start, int _index)
{
  String _str= "";
  if (list.length > _start)
    {
      _str = _header + (_index+ 1).toString() +_div;
      for (int i = _start; i< list.length; i++)
      {
        if(list[i] !="")
          _str += list[i] + _div;
      }
    }
  _str = _str + '@';
  print(_str);
  return _str;
}
