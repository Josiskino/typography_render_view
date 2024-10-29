import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotating Characters',
      home: RotatingCharactersScreen(),
    );
  }
}

class RotatingCharactersScreen extends StatefulWidget {
  @override
  _RotatingCharactersScreenState createState() => _RotatingCharactersScreenState();
}

class _RotatingCharactersScreenState extends State<RotatingCharactersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Liste des caractères chinois
  final List<String> characters = [
    '你', '好', '世', '界', '中', '国', '文', '化',
    '艺' 
  ];

  @override
  void initState() {
    super.initState();
    // Contrôleur d'animation pour l'ensemble des caractères
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Durée de la rotation complète
    )..repeat(); // Répéter l'animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi, // Rotation de l'ensemble
              child: Stack(
                children: List.generate(characters.length, (index) {
                  return RotatingCharacter(
                    character: characters[index],
                    index: index,
                    totalCharacters: characters.length,
                    rotationAngle: _controller.value * 2 * pi, // Angle de rotation pour chaque caractère
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
  final int index;
  final int totalCharacters;
  final double rotationAngle;

  const RotatingCharacter({
    Key? key,
    required this.character,
    required this.index,
    required this.totalCharacters,
    required this.rotationAngle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double angle = (2 * pi * index) / totalCharacters; // Calcul de l'angle
    double radius = 80; // Rayon du cercle

    // Positionnement des caractères
    double x = radius * cos(angle + rotationAngle);
    double y = radius * sin(angle + rotationAngle);

    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + x - 10, // Centrer horizontalement
      top: MediaQuery.of(context).size.height / 2 + y - 10, // Centrer verticalement
      child: Text(
        character,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}