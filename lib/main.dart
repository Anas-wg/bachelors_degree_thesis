import 'package:first_app/game/game_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  debugProfileBuildsEnabled = true; // Build 단계 프로파일링 활성화
  debugProfilePaintsEnabled = true; // Paint 단계 프로파일링 활성화
  runApp(
    const GetMaterialApp(
      home: Scaffold(
        body: GameStart(),
      ),
    ),
  );
}
