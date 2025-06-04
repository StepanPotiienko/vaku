import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(500, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class CirclesGradient extends AnimatedWidget {
  const CirclesGradient({super.key, required Animation<double> animation})
    : super(listenable: animation);

  static final List<Color> circlesColors = [
    Colors.blue.shade200,
    Colors.blue.shade300,
    Colors.blue.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: animation.value + 40,
          backgroundColor: circlesColors[0],
        ),
        CircleAvatar(
          radius: animation.value + 20,
          backgroundColor: circlesColors[1],
        ),
        CircleAvatar(
          radius: animation.value + 5,
          backgroundColor: circlesColors[2],
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin<MyHomePage> {
  late AnimationController controller;
  late Animation<double> animation;

  final player = AudioPlayer();

  static const List<String> welcomingMessagesList = [
    "Welcome to VaKu.",
    "The circles above indicate your breathing pattern.",
    "Let’s take a deep breath together.",
    "Breathe in… Breathe out…",
  ];

  int messageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    const List<String> songsList = ['music/ambient.mp3', 'music/wet_hands.mp3'];
    int songId = Random().nextInt(songsList.length);
    _playMusic(songsList[songId]);

    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    animation = Tween<double>(begin: 5, end: 20).animate(curvedAnimation);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          messageIndex = (messageIndex + 1) % welcomingMessagesList.length;
        });
        await Future.delayed(const Duration(seconds: 1));
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  Future<void> _playMusic(String songUrl) async {
    await player.play(AssetSource(songUrl));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CirclesGradient(animation: animation),
                ),
                const SizedBox(height: 20),
                Text(
                  welcomingMessagesList[messageIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Verdana",
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
