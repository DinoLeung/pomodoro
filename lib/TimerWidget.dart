import 'dart:async';
import 'dart:web_audio';
import 'dart:html' as html;

import 'package:flutter_web/material.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget({Key key, this.duration, this.tick, this.onTick})
      : super(key: key);
  final Duration duration;
  final Duration tick;
  final Function onTick;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  static final Duration _defaultTick = Duration(milliseconds: 500);
  static final Duration _defaultDuration = Duration(minutes: 25);
  static final Function _defaultOnTick = (String d) => {};
  static final TextStyle _timeTextStyle =
      TextStyle(color: Colors.white, fontSize: 30);
  static final SnackBar _breakMessage = SnackBar(
      content: Text('It\'s time to take a break!',
          style: TextStyle(fontFamily: 'IBM Plex Sans')));

  Timer _timer;
  Duration _duration;
  Duration _tick;
  Function _onTick;
  Duration _countdown;
  DateTime _endTime;
  String _buttonText;
  String _displayTime;

  @override
  void initState() {
    setState(() {
      _duration = widget.duration ?? _defaultDuration;
      _tick = widget.tick ?? _defaultTick;
      _onTick = widget.onTick ?? _defaultOnTick;
      resetTimer();
    });
    super.initState();
  }

  String getDisplayTime(Duration time) {
    int minutes = time.inMinutes;
    int seconds = (time.inSeconds - (time.inMinutes * 60));
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer(BuildContext context) {
    _endTime = DateTime.now().add(_duration);
    _timer = Timer.periodic(
        _tick,
        (Timer timer) => setState(() {
              _countdown = _endTime.difference(DateTime.now());
              _displayTime = getDisplayTime(_countdown);
              _onTick(_displayTime);
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
        _displayTime = getDisplayTime(_countdown);
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
        _onTick(_displayTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          width: 300,
          child: CircularProgressIndicator(
            value: _countdown.inMilliseconds / _duration.inMilliseconds,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _displayTime,
                  style: _timeTextStyle,
                ),
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
    );
  }
}
