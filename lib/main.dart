import 'package:flutter/material.dart';
import 'package:nordine_app/success_screen.dart';
import 'package:nordine_app/loose_screen.dart';

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

        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      if (status == AnimationStatus.dismissed) {
        print('dismissed');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LooseScreen(),
          ),
        );
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
