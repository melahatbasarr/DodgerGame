import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/dodger_game.dart';
import 'overlays/game_over_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DodgerGame game;

  bool showGameOver = false;
  int finalScore = 0;

  @override
  void initState() {
    super.initState();

    game = DodgerGame(
      onGameOver: (score) {
        setState(() {
          finalScore = score;
          showGameOver = true;
        });
      },
    );
  }

  void _restartGame() {
    setState(() {
      showGameOver = false;
      finalScore = 0;
    });

    game.restartGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                game.movePlayerToX(details.localPosition.dx);
              },
              onPanUpdate: (details) {
                game.movePlayerToX(details.localPosition.dx);
              },
              child: GameWidget(
                game: game,
              ),
            ),
            if (showGameOver)
              Positioned.fill(
                child: GameOverOverlay(
                  score: finalScore,
                  onRestart: _restartGame,
                ),
              ),
          ],
        ),
      ),
    );
  }
}