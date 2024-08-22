import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import '../ember_quest.dart';

class FireWeapon extends SpriteAnimationComponent
    with HasGameReference<EmberQuestGame> {
  final Vector2 initialPosition;
  final Vector2 direction;
  double speed;

  FireWeapon({
    required this.initialPosition,
    required this.direction,
    this.speed = 500.0, // Harakat tezligini sozlash
  }) : super(size: Vector2.all(16), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Sprite animatsiyasini sozlash
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('fire.png'),
      SpriteAnimationData.sequenced(
        amount: 4, // Bir nechta ramka bo‘lishi mumkin
        textureSize: Vector2.all(16),
        stepTime: 0.1, // Ramkalar orasidagi vaqt
      ),
    );

    // Pozitsiyani belgilash
    position = initialPosition;

    // To‘qnashuvni aniqlash
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Harakat effekti qo‘shish
    add(
      MoveEffect.by(
        direction * speed * 4,
        EffectController(
          duration: 3, // Harakat davomiyligi
          alternate: false, // Effektda almashtirish bo‘lmasligi
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }
  }
}
