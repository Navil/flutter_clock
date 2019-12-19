import 'dart:async';
import 'dart:ui';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          backgroundColor: Colors.pink.shade50,
          accentColor: Colors.purpleAccent,
          textTheme: TextTheme(
              display1: GoogleFonts.bungee(
                  fontSize: 150,
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
  }

  void _updateClock() async {
    _now = DateTime.now();

    setState(() {
      if (_now.second == 0) {
        _animationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          child: Stack(children: [
            _buildTime(),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: SecondPainter(_now.second / 60),
            )
          ]),
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                //Colors.purple.withOpacity(
                //((_now.second * 1000 + _now.millisecond) / 60000) * 0.7),
                // Colors.purple.withOpacity(0.7),

                Colors.purple.withOpacity(0.0),
                Colors.purple.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
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
          border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
      child: Stack(
        children: [
          animate
              ? _buildSlidingText(lastNumber.toString(), Offset.zero,
                  animate ? Offset(0.0, -2) : Offset.zero)
              : Container(),
          _buildSlidingText(number.toString(),
              animate ? Offset(0.0, 2) : Offset.zero, Offset.zero)
        ],
      ),
    ));
  }

  Widget _buildSlidingText(String text, Offset begin, Offset end) {
    return Center(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: end,
        ).animate(_animation),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _everySecond.cancel();
    _animationController.dispose();
    super.dispose();
  }
}

class SecondPainter extends CustomPainter {
  final double height;
  SecondPainter(this.height);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple.withOpacity(0.2);
    canvas.drawRect(
        Rect.fromLTRB(
            0, size.height, size.width, size.height - (size.height * height)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
