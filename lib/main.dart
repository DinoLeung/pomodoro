import 'package:flutter/material.dart';
import 'package:pomodoro/TimerWidget.dart';

void main() => runApp(BaseApp());

class BaseApp extends StatefulWidget {
  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  String _title = 'Pomodoro Timer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
          primarySwatch: Colors.lightGreen, fontFamily: 'IBM Plex Sans'),
      home: Scaffold(
        backgroundColor: Colors.redAccent[100],
        appBar: AppBar(
            title:
                Image.asset('assets/image/tomato.png', width: 40, height: 40)),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: FittedBox(
              child: TimerWidget(
                duration: Duration(minutes: 25),
                tick: Duration(seconds: 1),
                onTick: (String countdown) => this.setState(() {
                  _title = countdown;
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
