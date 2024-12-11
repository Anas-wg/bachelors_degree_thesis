import 'dart:ui'; // Size와 Offset을 사용하기 위해 import
import 'package:get/get.dart';
import 'dart:math' as math;

class PuzzleController extends GetxController {
  var blocks = <BlockClass>[].obs;

  int gridSize = 3;
  double snapSensitivity = 0.5;

  RxBool isCompleted = false.obs;

  void initializePuzzle(Image fullImage, Size screenSize) {
    // 수정된 부분
    blocks.clear();
    final double widthPerBlock = screenSize.width / gridSize;
    final double heightPerBlock = screenSize.height / gridSize;

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final randomOffset = Offset(
          (math.Random().nextDouble() - 0.5) * 100,
          (math.Random().nextDouble() - 0.5) * 100,
        );

        final offsetDefault = Offset(x * widthPerBlock, y * heightPerBlock);

        blocks.add(BlockClass(
          offset: randomOffset.obs,
          offsetDefault: offsetDefault,
          isDone: false.obs,
        ));
      }
    }
  }

  void checkCompletion() {
    if (blocks.every((block) => block.isDone.value)) {
      isCompleted.value = true;
    }
  }

  void moveBlock(int index, Offset newOffset) {
    blocks[index].offset.value = newOffset;

    final block = blocks[index];
    if ((block.offset.value - block.offsetDefault).distance <
        snapSensitivity * 100) {
      block.offset.value = block.offsetDefault;
      block.isDone.value = true;
      checkCompletion();
    }
  }
}

class BlockClass {
  Rx<Offset> offset;
  Offset offsetDefault;
  RxBool isDone;

  BlockClass({
    required this.offset,
    required this.offsetDefault,
    required this.isDone,
  });
}
