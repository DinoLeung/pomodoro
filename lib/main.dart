import 'dart:async';

import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  Timer _timer = Timer(Duration(milliseconds: 10), () {});
  double _time = 10.0;
  String _buttonText = 'Start';

  void startTimer() {
    _timer = Timer.periodic(
        Duration(milliseconds: 10),
        (Timer timer) => setState(() {
              if (_time < 0.01) {
                stopTimer();
              } else {
                _time -= 0.01;
              }
            }));
    _buttonText = 'Stop';
  }

  void stopTimer() => setState(() {
        _buttonText = 'Reset';
        _timer.cancel();
      });

  void resetTimer() => setState(() {
        _time = 10.0;
        _buttonText = 'Start';
      });

  void buttonPress() {
    if (_timer.isActive) {
      stopTimer();
    } else {
      if (_time == 10.0) {
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
                      value: _time / 10,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_time.toStringAsFixed(2)}',
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
