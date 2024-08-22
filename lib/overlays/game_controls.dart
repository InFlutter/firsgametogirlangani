import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:n11game/ember_quest.dart';

enum Direction { left, right, none }

class GameControls extends StatelessWidget {
  final EmberQuestGame game;
  const GameControls({super.key, required this.game});



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 50,
          left: 20,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Joystick(
              listener: (details) {
                if (details.x < 0) {
                  game.movePlayer(Direction.left);
                } else if (details.x > 0) {
                  game.movePlayer(Direction.right);
                }
              },
              onStickDragEnd: () {
                game.stopPlayer();
              },
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: ElevatedButton(
            onPressed: () {
              game.jumpPlayer();
              // playSound('sounds/jump.ogg');
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.grey,
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 90,
          child: ElevatedButton(
            onPressed: () {
              game.fireWeapon(); // Call the fire function when the button is pressed
              // playSound('sounds/gun.ogg');
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.red,
            ),
            child: const Icon(Icons.fireplace, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
