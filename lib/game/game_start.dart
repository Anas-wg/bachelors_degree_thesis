import 'package:first_app/design_palette.dart';
import 'package:first_app/game/game_jigsaw_puzzle.dart';
import 'package:first_app/game/game_overlay_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameStart extends StatefulWidget {
  const GameStart({super.key});

  @override
  State<GameStart> createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff706464),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/dice-6.png')),
            const SizedBox(height: 24),
            const SizedBox(
              width: 258,
              child: Text(
                textAlign: TextAlign.center,
                "알람을 해제하려면 그룹 미션 퍼즐을 완성하세요",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(369, 48),
                  foregroundColor: Colors.white,
                  backgroundColor: ColorStyles.secondaryOrange),
              onPressed: () {
                Get.to(
                  JigsawPuzzle(
                    gridSize: 3,
                    image: const AssetImage('assets/images/dice-6.png'),
                    onFinished: () {
                      OverlayUtil.showCompletionOverlay(context, () {
                        Get.offAll(() => const GameStart());
                      });
                    },
                  ),
                );
              },
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
