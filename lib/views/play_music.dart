import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  
  // This is then instance of Audio Player and it will be initialized in initState()
  late AudioPlayer audioPlayer;
  // This variable will maintain the state of player.
  bool isPlaying = false;

  // These 2 variables are used in progress slider which tell how much progress song has made.
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Source of song that need to be played.
  String songLink = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void initState() {
    super.initState();
    // Creating an instance of Audio Player
    audioPlayer = AudioPlayer();

    // Changing state
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        // This expression will compare current state. If current state is not playing it will set isPlaying to false.
        isPlaying = (state == PlayerState.playing);
      });
    });


    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });

    audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  void playMusic() async {
    try {
      await audioPlayer.play(UrlSource(songLink));
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  void pauseMusic() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      print('Error pausing music: $e');
    }
  }

  void resumeMusic() async {
    try {
      await audioPlayer.resume();
    } catch (e) {
      print('Error resuming music: $e');
    }
  }

  void stopMusic() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Album cover
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                        // Replace this with song cover image if any.
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Song title
            Text(
              'SoundHelix Song',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Artist name
            const Text(
              'SoundHelix',
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
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
                if (isPlaying) {
                  await audioPlayer.resume();
                }
              },
            ),

            // Music controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  color: Colors.grey.shade900,
                  iconSize: 36,
                  onPressed: () {
                    // Handle previous track
                  },
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Colors.grey.shade900,
                  iconSize: 48,
                  onPressed: isPlaying ? pauseMusic : playMusic,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  color: Colors.grey.shade900,
                  iconSize: 36,
                  onPressed: () {
                    // Handle next track
                  },
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
