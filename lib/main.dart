import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      debugShowCheckedModeBanner: false,
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double height;
  double width;
  DateTime _now;
  Timer _everySecond;

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    _now = DateTime.now();

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _updateClock();
    });
    _animationController.forward();
  }

  void _updateClock() async {
    _now = DateTime.now();

    if (_now.second == 0) {
      setState(() {
        _animationController.reset();
        _animationController.forward();
      });
    }
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
    DateTime lastSecond = _now.subtract(Duration(seconds: 1));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildGenericDigit(_now.hour ~/ 10, lastSecond.hour ~/ 10,
            _now.hour ~/ 10 != lastSecond.hour ~/ 10),
        _buildGenericDigit(_now.hour % 10, lastSecond.hour % 10,
            _now.hour % 10 != lastSecond.hour % 10),
        _buildGenericDigit(_now.minute ~/ 10, lastSecond.minute ~/ 10,
            _now.minute ~/ 10 != lastSecond.minute ~/ 10),
        _buildGenericDigit(_now.minute % 10, lastSecond.minute % 10,
            _now.minute % 10 != lastSecond.minute % 10),
      ],
    );
  }

  Widget _buildGenericDigit(int number, int lastNumber, bool animate) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 5),
          color: Theme.of(context).accentColor.withOpacity(0.7)),
      child: Stack(
        children: [
          animate
              ? Center(
                  child: SlideTransition(
                    position: Tween<Offset>(
                            end: animate ? Offset(0.0, -10) : Offset.zero,
                            begin: Offset.zero)
                        .animate(_animation),
                    child: Text(
                      (number - 1).toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                )
              : Container(),
          Center(
            child: SlideTransition(
              position: Tween<Offset>(
                      begin: animate ? Offset(0.0, 10) : Offset.zero,
                      end: Offset.zero)
                  .animate(_animation),
              child: Text(
                number.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          )
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }
}
