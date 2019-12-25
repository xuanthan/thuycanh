import 'dart:io';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  Singleton._internal();
  static Singleton get instance => _singleton;

  List<String> strAlarm = null;
  int size ;
  List<String> statusLed;
  List<String> statusFan;
  List<String> statusPump;
  List<double> valueBrightness;
  List<List<String>> alarmLed;
  List<List<String>> alarmFan;
  List<List<String>> alarmPump;
  int lengthLed = 0;
  int lengthFan = 0;
  int lengthPump = 0;
  Socket socket;
  String temperature ;
  String humidity;
  String pH ;
  String waterLevel ;
  String tds ;
  bool statusApp = false;
  int indexlist = 0;
  String headerAlarm;
  List<String> statusAlarm;
  String  testrunapp = "";
}