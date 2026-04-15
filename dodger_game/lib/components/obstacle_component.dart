import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/dodger_game.dart';

class ObstacleComponent extends RectangleComponent
    with HasGameReference<DodgerGame>, CollisionCallbacks {
  final double speed;

  ObstacleComponent({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFF6B6B),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    position.y += speed * dt;

    if (position.y - (size.y / 2) > game.size.y) {
      removeFromParent();
    }
  }
}