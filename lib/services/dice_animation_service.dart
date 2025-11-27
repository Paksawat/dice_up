import 'dart:math';
import 'package:flutter/material.dart';

typedef RollingValueCallback = void Function(int index, int value);

class DiceAnimationService {
  final List<AnimationController> controllers = [];
  final List<Animation<double>> rotationAnimations = [];
  final Random random = Random();
  RollingValueCallback? onRollingValueUpdate;

  void initialize(
    int numberOfDice,
    TickerProvider vsync, {
    RollingValueCallback? onRollingValueUpdate,
  }) {
    this.onRollingValueUpdate = onRollingValueUpdate;
    dispose();
    
    for (int i = 0; i < numberOfDice; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: vsync,
      );

      final animation = Tween<double>(
        begin: 0,
        end: 4 * pi,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      final index = i;
      controller.addListener(() {
        final callback = onRollingValueUpdate;
        if (callback != null) {
          final frame = (controller.value * 20).floor();
          callback(index, (frame % 6) + 1);
        }
      });

      controllers.add(controller);
      rotationAnimations.add(animation);
    }
  }

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    rotationAnimations.clear();
  }

  int generateRandomValue() => random.nextInt(6) + 1;
}

