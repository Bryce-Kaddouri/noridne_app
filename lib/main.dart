import 'package:flutter/material.dart';
import 'package:nordine_app/success_screen.dart';

void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  bool isBombExploded = false;
  bool isBombDefused = false;
  String secretCode = 'Nemesis';
  // global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // text editing controller for the text field
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(minutes: 3),
      vsync: this,
    );
    animationController.reverse(from: 1);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('completed');
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
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
                            setState(() {
                              isBombDefused = true;
                            });
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
    );
  }
}
