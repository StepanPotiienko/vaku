import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(500, 700);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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

String pickRandomSong() {
  const songsList = ['music/ambient.mp3', 'music/wet_hands.mp3'];
  int songId = Random().nextInt(songsList.length);
  return songsList[songId];
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final player = AudioPlayer();
  bool isMusicPlaying = false;
  final PageController pageController = PageController();
  int currentPage = 0;

  static const List<String> welcomingMessagesList = [
    "Welcome to VaKu.",
    "The circles above indicate your breathing pattern.",
    "Let’s take a deep breath together.",
    "Breathe in… Breathe out…",
    "There is no need to stress. Everything will be alright.",
  ];

  int messageIndex = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

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
    if (isMusicPlaying) await player.play(AssetSource(songUrl));
  }

  @override
  void dispose() {
    controller.dispose();
    player.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeContent(
            animation: animation,
            message: welcomingMessagesList[messageIndex],
          ),
          const SettingsPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          if (isMusicPlaying) {
            _playMusic(pickRandomSong());
          }

          setState(() {
            isMusicPlaying = !isMusicPlaying;
          });
        },
      ),
      bottomNavigationBar: FancyBottomNavigationPlus(
        circleColor: Colors.lightBlue.shade100,
        tabs: [
          TabData(icon: const Icon(Icons.home), title: 'Home'),
          TabData(icon: const Icon(Icons.settings), title: 'Settings'),
        ],
        onTabChangedListener: (index) {
          setState(() => currentPage = index);
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Animation<double> animation;
  final String message;

  const HomeContent({
    super.key,
    required this.animation,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
            message,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Verdana",
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings', style: TextStyle(fontSize: 24)),
    );
  }
}
