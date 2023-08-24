import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 0.7;
  double playbackRate = 1.0;

  String formatTime(int seconds) {
    List time = '${(Duration(seconds: seconds))}'.split('.')[0].split(':');
    return '${time[1]}:${time[2]}';
  }

  @override
  void initState() {
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(
        () {
          position = newPosition;
        },
      );
    });
  }

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(seconds: value.toInt());
                      player.seek(position);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(18, 32, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(position.inSeconds),
                          textScaleFactor: 0.75,
                        ),
                        Text(
                          formatTime((duration).inSeconds),
                          textScaleFactor: 0.75,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(size: 30, Icons.skip_previous),
                    onPressed: () => 0,
                  ),
                  IconButton(
                    icon: Icon(size: 30, Icons.replay_5),
                    onPressed: () =>
                        player.seek(Duration(seconds: position.inSeconds - 5)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        size: 35,
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          player.pause();
                        } else {
                          player.play(UrlSource(
                              'https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac'));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(size: 30, Icons.forward_5),
                    onPressed: () =>
                        player.seek(Duration(seconds: position.inSeconds + 5)),
                  ),
                  IconButton(
                    icon: Icon(size: 30, Icons.skip_next),
                    onPressed: () => 0,
                  ),
                ],
              ),
              Stack(children: [
                Slider(
                  thumbColor: Colors.grey,
                  activeColor: Colors.grey,
                  min: 0.0,
                  max: 1.0,
                  value: volume,
                  onChanged: (value) {
                    volume = value;
                    player.setVolume(volume);
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.volume_down),
                      Icon(Icons.volume_up),
                    ],
                  ),
                ),
              ]),
              Stack(children: [
                Slider(
                  divisions: 4,
                  thumbColor: Colors.grey,
                  activeColor: Colors.grey,
                  min: 0.5,
                  max: 1.5,
                  value: playbackRate,
                  onChanged: (value) {
                    playbackRate = value;
                    player.setPlaybackRate(playbackRate);
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 32, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0.5x',
                        textScaleFactor: 0.75,
                      ),
                      Text(
                        '0.85x',
                        textScaleFactor: 0.75,
                      ),
                      Text(
                        '1.0x',
                        textScaleFactor: 0.75,
                      ),
                      Text(
                        '1.25x',
                        textScaleFactor: 0.75,
                      ),
                      Text(
                        '1.5x',
                        textScaleFactor: 0.75,
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
