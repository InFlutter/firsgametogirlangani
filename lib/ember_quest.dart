import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:n11game/objects/fire_weapon.dart';

import 'actors/actors.dart';
import 'managers/segment_manager.dart';
import 'objects/objects.dart';
import 'overlays/overlays.dart';

class EmberQuestGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  double objectSpeed = 0.0;
  late EmberPlayer _ember;
  int starsCollected = 0;
  int health = 3;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'fire.png'
    ]);
    playSound('sounds/start.m4a');
    camera.viewfinder.anchor = Anchor.topLeft;
    initializeGame(true);
  }

  void playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  void initializeGame(bool loadHud) {
    // Ekran segmentlarini yuklash
    final segmentsToLoad = (size.x / 320).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i < segmentsToLoad; i++) {
      loadGameSegments(i, (320 * i).toDouble());
    }

    // O'yinchini boshlang'ich pozitsiyaga qo'shish
    _ember = EmberPlayer(
      position: Vector2(64, canvasSize.y - 128),
    );
    add(_ember);

    // Hudni faqat bir marta qo'shish
    if (loadHud && !children.any((c) => c is Hud)) {
      add(Hud());
    }
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    int lastGroundBlockX = -4; // Initialize with an out-of-bounds value

    for (final block in segments[segmentIndex]) {
      if (block.blockType is GroundBlock) {
        final gridX = block.gridPosition.x.toInt();
        if (gridX - lastGroundBlockX > 3) {
          for (int i = lastGroundBlockX + 1; i < gridX; i++) {
            world.add(
              GroundBlock(
                gridPosition: Vector2(i.toDouble(), block.gridPosition.y),
                xOffset: xPositionOffset,
              ),
            );
          }
        }
        lastGroundBlockX = gridX;
      }

      switch (block.blockType) {
        case GroundBlock:
          world.add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          add(
            PlatformBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case Star:
          world.add(
            Star(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case WaterEnemy:
          world.add(
            WaterEnemy(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
      }
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  void movePlayer(Direction direction) {
    switch (direction) {
      case Direction.left:
        _ember.horizontalDirection = -1;
        break;
      case Direction.right:
        _ember.horizontalDirection = 1;
        break;
      case Direction.none:
        break;
    }
  }

  void fireWeapon() {
    final fireWeapon = FireWeapon(
      initialPosition: _ember.position +
          Vector2(16, 0), // Position the fireball relative to the player
      direction: Vector2(1, 0), // Move to the right
    );
    add(fireWeapon);
    playSound('sounds/gun.ogg');
  }

  void jumpPlayer() {
    _ember.hasJumped = true;
    playSound('sounds/jump.ogg');
  }

  void stopPlayer() {
    _ember.horizontalDirection = 0;
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (health <= 0) {
      playSound('sounds/game_over.wav');

      overlays.add('GameOver');
    }
  }
}
