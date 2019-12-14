import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_clock/WaveWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          backgroundColor: Colors.pink.shade50,
          accentColor: Colors.purpleAccent,
          textTheme: TextTheme(
              display1: GoogleFonts.bungee(
                  fontSize: 200,
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(color: Colors.purple)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double height;
  double width;
  DateTime _now;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();

    // sets first value
    _now = DateTime.now();

    // defines a timer
    _everySecond = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _buildTime(),
    );
  }

  Widget _buildTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildDigit((_now.hour ~/ 10).toString()),
        _buildDigit((_now.hour % 10).toString()),
        _buildDigit((_now.minute ~/ 10).toString()),
        _buildDigit((_now.minute % 10).toString())
      ],
    );
  }

  Widget _buildDigit(String time) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 5),
          color: Theme.of(context).accentColor.withOpacity(0.7)),
      child: Center(
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }
}
