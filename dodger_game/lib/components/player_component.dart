import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/dodger_game.dart';
import 'obstacle_component.dart';

class PlayerComponent extends RectangleComponent
    with HasGameReference<DodgerGame>, CollisionCallbacks {
  PlayerComponent()
      : super(
          size: Vector2(90, 22),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF4DD0E1),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = Vector2(
      game.size.x / 2,
      game.size.y - 60,
    );

    add(RectangleHitbox());
  }

  void moveToX(double x) {
    final double halfWidth = size.x / 2;

    final double clampedX = x.clamp(
      halfWidth,
      game.size.x - halfWidth,
    );

    position.x = clampedX;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ObstacleComponent) {
      game.gameOver();
    }
  }
}