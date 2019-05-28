import 'dart:async';
import 'dart:web_audio';
import 'dart:html' as html;

import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen, fontFamily: 'IBM Plex Sans'),
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
  static final Duration _defaultDuration = Duration(minutes: 25);
  static final TextStyle _timeTextStyle =
      TextStyle(color: Colors.white, fontSize: 30);
  static final SnackBar _breakMessage = SnackBar(
      content: Text('It\'s time to take a break!',
          style: TextStyle(fontFamily: 'IBM Plex Sans')));
  Timer _timer;
  Duration _duration = _defaultDuration;
  Duration _countdown = _defaultDuration;
  DateTime _endTime;
  String _buttonText = 'Start';

  void startTimer(BuildContext context) {
    _endTime = DateTime.now().add(_duration);
    _timer = Timer.periodic(
        _tick,
        (Timer timer) => setState(() {
              _countdown = _endTime.difference(DateTime.now());
              if (DateTime.now().isAfter(_endTime)) {
                stopTimer();
                alarmRing();
                Scaffold.of(context).showSnackBar(_breakMessage);
              }
            }));
    _buttonText = 'Stop';
  }

  void stopTimer() => setState(() {
        _buttonText = 'Reset';
        _timer.cancel();
      });

  void resetTimer() => setState(() {
        _countdown = _duration;
        _buttonText = 'Start';
      });

  void alarmRing() {
    AudioContext audioContext = new AudioContext();
    html.HttpRequest.request('./assets/ring.ogg', responseType: 'arraybuffer')
        .then((html.HttpRequest request) => audioContext
                .decodeAudioData(request.response)
                .then((AudioBuffer buffer) {
              AudioBufferSourceNode source = audioContext.createBufferSource();
              source.buffer = buffer;
              source.connectNode(audioContext.destination);
              source.start(audioContext.currentTime);
            }));
  }

  void buttonPress(BuildContext context) {
    if (_timer?.isActive ?? false) {
      stopTimer();
    } else {
      if (_countdown == _duration) {
        startTimer(context);
      } else {
        resetTimer();
      }
    }
  }

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
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: CircularProgressIndicator(
                            value: _countdown.inMilliseconds /
                                _duration.inMilliseconds,
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.lime),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${_countdown.inMinutes}',
                                  style: _timeTextStyle,
                                ),
                                Text(
                                  ':',
                                  style: _timeTextStyle,
                                ),
                                Text(
                                  (_countdown.inSeconds -
                                          (_countdown.inMinutes * 60))
                                      .toString()
                                      .padLeft(2, '0'),
                                  style: _timeTextStyle,
                                )
                              ],
                            ),
                            FlatButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text(_buttonText),
                              shape: StadiumBorder(),
                              onPressed: () => buttonPress(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
