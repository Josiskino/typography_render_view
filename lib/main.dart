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
      title: 'Unique Rotating Characters',
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
  late final Animation<double> _outerRotationAnimation;
  late final Animation<double> _innerRotationAnimation1;
  late final Animation<double> _innerRotationAnimation2;
  late final Animation<double> _innerRotationAnimation3;
  late final Animation<double> _radiusAnimation;
  late final Animation<double> _innerRadius1Animation;
  late final Animation<double> _innerRadius2Animation;
  late final Animation<double> _innerRadius3Animation;

  bool _showColorPicker = false;
  Color _selectedColor = Colors.black;
  int _selectedColorIndex = -1;

  // Liste des couleurs disponibles
  final List<Color> _availableColors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
  ];

  // Augmentation du nombre de caractères pour les grands cercles
  final List<String> outerCharacters = [
    '日', '月', '星', '云', '雨', '雪', '风', '火', '山', '水', '林', '天',
    '光', '暗', '空', '地', '海', '河', '木', '石', // Ajout de caractères
  ];
  final List<String> middleCharacters1 = [
    '金', '木', '水', '火', '土', '风', '雷', '电', '气', '光', '影', '虹',
    '霜', '露', '云', '雾', // Ajout de caractères
  ];
  final List<String> middleCharacters2 = [
    '爱', '恨', '情', '义', '力', '智', '勇', '仁', '信', '礼', '廉', '耻',
    '德', '善', // Ajout de caractères
  ];
  final List<String> innerCharacters = [
    '春',
    '夏',
    '秋',
    '冬',
    '岁',
    '月',
    '日',
    '时',
    '分',
    '秒',
    '晨',
    '暮',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    // Ajustement des rayons pour plus d'espacement
    _radiusAnimation = Tween<double>(begin: 100, end: 150).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _innerRadius1Animation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _innerRadius2Animation = Tween<double>(begin: 60, end: 90).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _innerRadius3Animation = Tween<double>(begin: 30, end: 50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Animations de rotation
    _outerRotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _innerRotationAnimation1 = Tween<double>(begin: 2 * pi, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuart,
      ),
    );

    _innerRotationAnimation2 = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _innerRotationAnimation3 = Tween<double>(begin: 2 * pi, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Icône crayon en haut de l'écran
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.edit,
                  color: _showColorPicker ? Colors.blue : Colors.black),
              onPressed: () {
                setState(() {
                  _showColorPicker = !_showColorPicker;
                });
              },
            ),
          ),

          // Animation des cercles
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final outerRotationAngle = _outerRotationAnimation.value;
                final innerRotationAngle1 = _innerRotationAnimation1.value;
                final innerRotationAngle2 = _innerRotationAnimation2.value;
                final innerRotationAngle3 = _innerRotationAnimation3.value;
                final radius = _radiusAnimation.value;
                final innerRadius1 = _innerRadius1Animation.value;
                final innerRadius2 = _innerRadius2Animation.value;
                final innerRadius3 = _innerRadius3Animation.value;

                return Stack(
                  children: [
                    // Outer circle
                    Transform.rotate(
                      angle: outerRotationAngle,
                      child: Stack(
                        children:
                            List.generate(outerCharacters.length, (index) {
                          final angle =
                              (2 * pi * index) / outerCharacters.length;
                          final x = radius * cos(angle + outerRotationAngle);
                          final y = radius * sin(angle + outerRotationAngle);

                          return Positioned(
                            left: screenWidth / 2 + x - 6,
                            top: screenHeight / 2 + y - 6,
                            child: RotatingCharacter(
                              character: outerCharacters[index],
                              size: 12,
                              color: _selectedColor,
                            ),
                          );
                        }),
                      ),
                    ),
                    // Autres cercles similaires avec leur couleur...
                    // [Code des autres cercles identique mais avec _selectedColor]
                    // Dans le Stack, après le premier cercle (outer circle), ajoutez :

// Inner circle 1
                    Transform.rotate(
                      angle: innerRotationAngle1,
                      child: Stack(
                        children:
                            List.generate(middleCharacters1.length, (index) {
                          final angle =
                              (2 * pi * index) / middleCharacters1.length;
                          final x =
                              innerRadius1 * cos(angle + innerRotationAngle1);
                          final y =
                              innerRadius1 * sin(angle + innerRotationAngle1);

                          return Positioned(
                            left: screenWidth / 2 + x - 5,
                            top: screenHeight / 2 + y - 5,
                            child: RotatingCharacter(
                              character: middleCharacters1[index],
                              size: 10,
                              color: _selectedColor,
                            ),
                          );
                        }),
                      ),
                    ),

// Inner circle 2
                    Transform.rotate(
                      angle: innerRotationAngle2,
                      child: Stack(
                        children:
                            List.generate(middleCharacters2.length, (index) {
                          final angle =
                              (2 * pi * index) / middleCharacters2.length;
                          final x =
                              innerRadius2 * cos(angle + innerRotationAngle2);
                          final y =
                              innerRadius2 * sin(angle + innerRotationAngle2);

                          return Positioned(
                            left: screenWidth / 2 + x - 4,
                            top: screenHeight / 2 + y - 4,
                            child: RotatingCharacter(
                              character: middleCharacters2[index],
                              size: 8,
                              color: _selectedColor,
                            ),
                          );
                        }),
                      ),
                    ),

// Inner circle 3
                    Transform.rotate(
                      angle: innerRotationAngle3,
                      child: Stack(
                        children:
                            List.generate(innerCharacters.length, (index) {
                          final angle =
                              (2 * pi * index) / innerCharacters.length;
                          final x =
                              innerRadius3 * cos(angle + innerRotationAngle3);
                          final y =
                              innerRadius3 * sin(angle + innerRotationAngle3);

                          return Positioned(
                            left: screenWidth / 2 + x - 3,
                            top: screenHeight / 2 + y - 3,
                            child: RotatingCharacter(
                              character: innerCharacters[index],
                              size: 6,
                              color: _selectedColor,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Color picker en bas
          if (_showColorPicker)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = _availableColors[index];
                            _selectedColorIndex = index;
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _availableColors[index],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedColorIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: _selectedColorIndex == index
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RotatingCharacter extends StatelessWidget {
  final String character;
  final double size;
  final Color color;

  const RotatingCharacter({
    super.key,
    required this.character,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      character,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}
