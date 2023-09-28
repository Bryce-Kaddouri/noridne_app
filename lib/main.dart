import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nordine_app/success_screen.dart';
import 'package:nordine_app/loose_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(

        useMaterial3: true,
      ),
      home:
      const MyHomePage(title: 'Flutter Demo Home Page'),


    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late final player = Player();


  String secretCode = 'Nemesis';
  // global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // text editing controller for the text field
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
   /* player.setPlaylistMode(PlaylistMode.loop);
    player.setVolume(1.0);
    player.open(Playlist([
      Media('assets/videos/video-nordine.mp3')
    ]));*/




    print(player.state);
    animationController = AnimationController(
      duration: const Duration(minutes: 3),
      vsync: this,
    );
    animationController.reverse(from: 1);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        print('dismissed');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LooseScreen(),
          ),
        );
      }
    });
    player.open(Playlist([
      Media('assets/videos/video-nordine.mp3')
    ]));
    player.setPlaylistMode(PlaylistMode.loop);
    /*player.open(
      Media('assets/videos/video-nordine.mp3')
    );*/
print('=' * 100);
    print(player.state);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
        child:
      Stack(children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child:
            AspectRatio(
        aspectRatio: 16 / 9,
        child:
        Image.asset('assets/videos/video-nordine.gif',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ),
      ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'Vous avez 3 minutes pour désamorcer la bombe !',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            // linear progress indicator with a fixed color

            Container(
              margin: const EdgeInsets.all(8),
              height: 100,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  int seconds = (animationController.value * 180).round();
                  String timer =
                      '${(seconds / 60).floor()}:${(seconds % 60).toString().padLeft(2, '0')}';
                  return Text(
                    timer,
                    style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    minHeight: 10,
                    value: 1 - animationController.value,
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          hintText: 'Entrez le code secret',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(60, 60),
                        ),
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        if (_textEditingController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 150,
                                ),
                                contentTextStyle: TextStyle(
                                  color: Colors.red,
                                ),
                                content: Text(
                                  'Veuillez entrer un code',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (_textEditingController.text == secretCode) {
                            animationController.stop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SuccessScreen();
                                },
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 150,
                                  ),
                                  contentTextStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                  content: Text(
                                    'Mauvais code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),

    ],
      ),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';

// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
*/
/*
import 'package:media_kit_video/media_kit_video.dart';          // Provides [VideoController] & [Video] etc.
*//*


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(
      home: MyScreen(),
    ),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
*/
/*
  late final controller = VideoController(player);
*//*


  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].

   player.open(Playlist([
     Media('assets/videos/video-nordine.mp3')
   ]));
   player.setPlaylistMode(PlaylistMode.loop);
   print(player.state);
   */
/*
    player.playOrPause();
    player.setPlaylistMode(PlaylistMode.loop);
    player.setVolume(1.0);
    player.open(Playlist([Media('assets/videos/video-nordine.mp3'), Media('assets/videos/video-nordine.mp3')]);*//*


    */
/*player.stream.playing.listen((event) {
      print(event);

      if(event == false){
        player.play();
      }
    });*//*

  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
*/
/*
        child: Video(controller: controller),
*//*

      ),
    );
  }

}*/