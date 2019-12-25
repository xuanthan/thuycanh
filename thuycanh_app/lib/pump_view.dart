import 'package:flutter/material.dart';
import 'singleton_data.dart';
//import 'constants.dart';

class PumpView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BodyPumpWidget(),
    );
  }
}

class BodyPumpWidget extends StatefulWidget {
  @override
  _BodyPumpWidgetState createState() => _BodyPumpWidgetState();
}

class _BodyPumpWidgetState extends State<BodyPumpWidget> {
  var singledata = Singleton.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Expanded(child: new ListView.builder(itemCount: singledata.lengthPump,
              itemBuilder: (context, index) => this._buildRow(index)),),
        ],
      ),
    );
  }

  _buildRow(int index) {
    return Container(
      padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 0.75, color: Colors.lightGreen),
          borderRadius:const BorderRadius.all(const Radius.circular(3.0)),
          color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
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
                    flex:2 ,
                    child: Text(""),
                  ),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      width: 32,
                      //    height: 32,
                      child: Text("Pump" + (index+1).toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0)),
                      //   child: Image.asset('image/pump-32.png'),
                    ),
                  ),
                  Expanded(
                    flex:3 ,
                    child: Text(""),
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
                         //     statusPUMP==Constants.STATUS_ON?statusPUMP=Constants.STATUS_OFF:statusPUMP=Constants.STATUS_ON;
                            });

                          },
                          child: Text(singledata.statusPump[index],
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
                            padding: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 22.0),
                            icon: Icon(Icons.access_alarm),
                            color: Color(0xFF70B45A),
                            onPressed: () {
                          //    goToPageAlarm(context);
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
