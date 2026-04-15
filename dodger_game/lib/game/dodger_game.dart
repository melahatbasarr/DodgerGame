import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/obstacle_component.dart';
import '../components/player_component.dart';

class DodgerGame extends FlameGame with HasCollisionDetection {
  DodgerGame({
    this.onGameOver,
  });

  final void Function(int score)? onGameOver;

  late PlayerComponent player;
  late TextComponent scoreText;

  final Random random = Random();

  double spawnTimer = 0;
  double spawnInterval = 1.0;
  double survivalTime = 0;

  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleComponent(
        size: Vector2(size.x, size.y),
        paint: Paint()..color = const Color(0xFF101820),
      ),
    );

    player = PlayerComponent();
    add(player);

    add(
      TextComponent(
        text: 'Dodger Game',
        position: Vector2(size.x / 2, 28),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 70),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    survivalTime += dt;
    scoreText.text = 'Score: ${survivalTime.floor()}';

    spawnTimer += dt;

    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      _spawnObstacle();
    }
  }

  void movePlayerToX(double x) {
    if (isGameOver) return;
    player.moveToX(x);
  }

  void _spawnObstacle() {
    const double obstacleWidth = 52;
    const double obstacleHeight = 52;

    final double minX = obstacleWidth / 2;
    final double maxX = size.x - (obstacleWidth / 2);

    final double randomX = minX + random.nextDouble() * (maxX - minX);

    add(
      ObstacleComponent(
        position: Vector2(randomX, -30),
        size: Vector2(obstacleWidth, obstacleHeight),
        speed: 230,
      ),
    );
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();

    onGameOver?.call(survivalTime.floor());
  }

  void restartGame() {
    children.whereType<ObstacleComponent>().toList().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    isGameOver = false;
    spawnTimer = 0;
    survivalTime = 0;
    scoreText.text = 'Score: 0';

    player.position = Vector2(
      size.x / 2,
      size.y - 60,
    );

    resumeEngine();
  }
}