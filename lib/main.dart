import 'dart:async';

import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'IBM Plex Sans'),
      home: MyHomePage(title: 'Tomato'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final Duration _tick = Duration(milliseconds: 10);
  Timer _timer;
  Duration _defaultTime = Duration(minutes: 25);
  Duration _countdown = Duration(minutes: 25);
  String _buttonText = 'Start';

  void startTimer() {
    _timer = Timer.periodic(
        _tick,
        (Timer timer) => setState(() {
              if (_countdown <= Duration.zero) {
                stopTimer();
              } else {
                _countdown -= _tick;
              }
            }));
    _buttonText = 'Stop';
  }

  void stopTimer() => setState(() {
        _buttonText = 'Reset';
        _timer.cancel();
      });

  void resetTimer() => setState(() {
        _countdown = _defaultTime;
        _buttonText = 'Start';
      });

  void buttonPress() {
    if (_timer?.isActive ?? false) {
      stopTimer();
    } else {
      if (_countdown == _defaultTime) {
        startTimer();
      } else {
        resetTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) => Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: CircularProgressIndicator(
                      value: _countdown.inMilliseconds /
                          _defaultTime.inMilliseconds,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_countdown.inMinutes}:${(_countdown.inSeconds - (_countdown.inMinutes * 60)).toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(_buttonText),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () => buttonPress(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
