import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';



class LooseScreen extends StatefulWidget {
  const LooseScreen({super.key});

  @override
  State<LooseScreen> createState() => _LooseScreenState();
}

class _LooseScreenState extends State<LooseScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  // function to play audio
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;

Future playAudio() async {
  UrlSource urlSource = UrlSource(
      'assets/audio/zombie.mp3');
  await audioPlayer.play(
    urlSource,
    volume: 1.0,
    position: const Duration(seconds: 0),
    mode: PlayerMode.lowLatency,
  );
  setState(() {
    isPlaying = true;
  });
}

@override
void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
  }

@override
void dispose() {
  audioPlayer.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/nemesis.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
