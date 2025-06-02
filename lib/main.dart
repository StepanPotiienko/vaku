import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  static const List<String> welcomingMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CirclesGradient(),
            Padding(padding: EdgeInsetsGeometry.all(5)),
            const Text(
              "Welcome to VaKu.",
              style: TextStyle(fontSize: 18, fontFamily: "Verdana"),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclesGradient extends StatelessWidget {
  const CirclesGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(radius: 100, backgroundColor: Colors.purple.shade200),
        CircleAvatar(radius: 75, backgroundColor: Colors.purple.shade300),
        CircleAvatar(radius: 50, backgroundColor: Colors.purple.shade400),
      ],
    );
  }
}
