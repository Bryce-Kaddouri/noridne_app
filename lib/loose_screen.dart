import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

class LooseScreen extends StatefulWidget {
  const LooseScreen({super.key});

  @override
  State<LooseScreen> createState() => _LooseScreenState();
}

class _LooseScreenState extends State<LooseScreen> {

  final AudioPlayer audioPlayer = AudioPlayer();
  late final player = AudioPlayer();




  // function to play audio
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;



Future playAudio() async {
  UrlSource urlSource = UrlSource(
      'assets/videos/video-nordine.mp3');
  await audioPlayer.play(
    urlSource,
    volume: 1.0,
    position: const Duration(seconds: 0),
    mode: PlayerMode.lowLatency,
  );


}

@override
void initState() {
    // TODO: implement initState
    super.initState();
    player.setSourceAsset('assets/videos/video-nordine.mp3');
    player.setPlayerMode(PlayerMode.lowLatency);
    player.setVolume(1.0);
    print(player.state);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset('assets/videos/video-nordine.gif',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          /*Image.asset('assets/videos/video-nordine.gif',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),*/
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          AssetSource assetSource = AssetSource(
              'assets/videos/video-nordine.mp3');
          AudioPlayer audioPlayer = AudioPlayer();
          try {
            await audioPlayer.play(
              assetSource,
              volume: 1.0,
              position: const Duration(seconds: 0),
              mode: PlayerMode.lowLatency,
            );
            print('playing');
            print(audioPlayer.state);
          } catch (e) {
            print(e);
          }
          /*await player.play(
            assetSource,
            volume: 1.0,
            position: const Duration(seconds: 0),
            mode: PlayerMode.lowLatency,
          );*/
        },
        child: const Icon(Icons.play_arrow),
      )
    );
  }
}

