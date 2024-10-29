import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotating Characters',
      home: RotatingCharactersScreen(),
    );
  }
}

class RotatingCharactersScreen extends StatefulWidget {
  const RotatingCharactersScreen({super.key});

  @override
  _RotatingCharactersScreenState createState() =>
      _RotatingCharactersScreenState();
}

class _RotatingCharactersScreenState extends State<RotatingCharactersScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _radiusAnimation;

  // Liste des caractères chinois
  final List<String> characters = [
    '你', '好', '世', '界', '中', '国', '文', '化', '艺', '你', '好', '世',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true); // Repeat in reverse mode for back-and-forth effect

    // Rotation speed variation: fast at start, then slow, reverse, and repeat
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic, // Ease-in-out effect for smooth speed changes
      ),
    );

    // Radius variation for expanding and contracting the circle of characters
    _radiusAnimation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth transition for radius expansion
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final rotationAngle = _rotationAnimation.value;
            final radius = _radiusAnimation.value;
            return Transform.rotate(
              angle: rotationAngle,
              child: Stack(
                children: List.generate(characters.length, (index) {
                  final angle = (2 * pi * index) / characters.length;
                  final x = radius * cos(angle + rotationAngle);
                  final y = radius * sin(angle + rotationAngle);

                  return Positioned(
                    left: screenWidth / 2 + x - 10,
                    top: screenHeight / 2 + y - 10,
                    child: RotatingCharacter(
                      character: characters[index],
                      size: 20 + (_controller.value * 5), // Vary font size slightly
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RotatingCharacter extends StatelessWidget {
  final String character;
  final double size;

  const RotatingCharacter({super.key, required this.character, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      character,
      style: TextStyle(color: Colors.black, fontSize: size), // Change text color to black for contrast
    );
  }
}
