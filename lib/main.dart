import 'package:flutter_web/material.dart';
import 'package:pomodoro/TimerWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen, fontFamily: 'IBM Plex Sans'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar:
          AppBar(title: Image.asset('image/tomato.png', width: 40, height: 40)),
      body: Builder(
          builder: (context) => Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: FittedBox(
                    child: TimerWidget(duration: Duration(minutes: 25)),
                  ),
                ),
              )),
    );
  }
}
