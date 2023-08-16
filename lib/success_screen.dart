import 'package:flutter/material.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    _controllerCenter.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: true,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.1,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                    createParticlePath: drawStar,
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 100),
            child: const Text(
              'Vous avez gagné !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
