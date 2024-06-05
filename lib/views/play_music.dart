import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Song song;

  const MusicPlayerScreen({super.key, required this.song});

  @override
  State<MusicPlayerScreen> createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = (state == PlayerState.playing);
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    playMusic(widget.song.url);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      print('Error pausing music: $e');
    }
  }

  Future<void> resumeMusic() async {
    try {
      await audioPlayer.resume();
    } catch (e) {
      print('Error resuming music: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.song.title,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.song.artist,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Slider(
              activeColor: Colors.grey.shade300,
              inactiveColor: Colors.grey.shade700,
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) async {
                final newPosition = Duration(seconds: value.toInt());
                await audioPlayer.seek(newPosition);
                if (isPlaying) {
                  await audioPlayer.resume();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Colors.grey.shade900,
                  iconSize: 48,
                  onPressed: isPlaying ? pauseMusic : resumeMusic,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
