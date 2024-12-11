import 'dart:async'; // Completer 사용을 위해 추가
import 'package:first_app/puzzle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class JigsawPuzzle extends StatelessWidget {
  final int gridSize;
  final ImageProvider image;
  final Function()? onFinished;

  JigsawPuzzle({
    Key? key,
    required this.gridSize,
    required this.image,
    this.onFinished,
  }) : super(key: key);

  final PuzzleController _controller = Get.put(PuzzleController());

  Future<ui.Image> _loadUiImage(
      BuildContext context, ImageProvider image) async {
    final completer = Completer<ui.Image>();
    final imageStream = image.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });
    imageStream.addListener(listener);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uiImage = await _loadUiImage(context, image);
      _controller.initializePuzzle(uiImage, screenSize);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Jigsaw Puzzle")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => SizedBox(
                width: screenSize.width,
                height: screenSize.width,
                child: Stack(
                  children: _controller.blocks.map((block) {
                    final index = _controller.blocks.indexOf(block);
                    return Obx(
                      () => Positioned(
                        left: block.offset.value.dx,
                        top: block.offset.value.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            _controller.moveBlock(
                              index,
                              block.offset.value + details.delta,
                            );
                          },
                          child: SizedBox(
                            width: screenSize.width / gridSize,
                            height: screenSize.width / gridSize,
                            child: CustomPaint(
                              painter: PuzzlePiecePainter(
                                image: image,
                                block: block,
                                gridSize: gridSize,
                                screenSize: screenSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => _controller.isCompleted.value
                  ? ElevatedButton(
                      onPressed: onFinished,
                      child: const Text("Puzzle Completed!"),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final ImageProvider image;
  final BlockClass block;
  final int gridSize;
  final Size screenSize;

  PuzzlePiecePainter({
    required this.image,
    required this.block,
    required this.gridSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final double widthPerBlock = screenSize.width / gridSize;
    final double heightPerBlock = screenSize.width / gridSize;

    final srcRect = Rect.fromLTWH(
      block.offsetDefault.dx,
      block.offsetDefault.dy,
      widthPerBlock,
      heightPerBlock,
    );
    final destRect = Rect.fromLTWH(0, 0, widthPerBlock, heightPerBlock);

    final imageStream = image.resolve(const ImageConfiguration());
    imageStream.addListener(
      ImageStreamListener(
        (ImageInfo info, _) {
          canvas.drawImageRect(info.image, srcRect, destRect, paint);
        },
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
