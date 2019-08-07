import 'package:flutter_web/material.dart';
import 'package:pomodoro/TimerWidget.dart';
import 'package:pomodoro/utils.dart';

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
            title: Image.asset('image/tomato.png', width: 40, height: 40)),
        body: Builder(
            builder: (context) => Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: FittedBox(
                      child: TimerWidget(
                          duration: Duration(minutes: 25),
                          tick: Duration(seconds: 1),
                          onTick: (Duration countdown) => this.setState(() {
                                _title = getDisplayTime(countdown);
                              })),
                    ),
                  ),
                )),
      ),
    );
  }
}
