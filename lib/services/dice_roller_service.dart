import 'package:flutter/foundation.dart';
import '../models/dice_state.dart';
import 'dice_animation_service.dart';

class DiceRollerService {
  final DiceAnimationService animationService;
  ValueChanged<DiceState>? onStateUpdate;

  DiceRollerService(this.animationService, {this.onStateUpdate});

  Future<void> rollDice(DiceState currentState) async {
    if (currentState.isAnyRolling) return;

    // Start rolling animation - reset reveal state
    var updatedState = currentState.copyWith(
      isRolling: List.generate(
        currentState.currentValues.length,
        (_) => true,
      ),
      rollingValues: List.generate(
        currentState.currentValues.length,
        (index) => animationService.generateRandomValue(),
      ),
      isRevealed: false,
      revealCountUsed: 0,
    );
    onStateUpdate?.call(updatedState);

    // Start all animations
    final futures = <Future<void>>[];
    for (int i = 0; i < animationService.controllers.length; i++) {
      final index = i;
      animationService.controllers[index].reset();
      futures.add(
        animationService.controllers[index].forward().then((_) {
          // Generate final value for this die
          final finalValue = animationService.generateRandomValue();
          updatedState = updatedState.copyWith(
            currentValues: [
              ...updatedState.currentValues.sublist(0, index),
              finalValue,
              ...updatedState.currentValues.sublist(index + 1),
            ],
            isRolling: [
              ...updatedState.isRolling.sublist(0, index),
              false,
              ...updatedState.isRolling.sublist(index + 1),
            ],
          );
          onStateUpdate?.call(updatedState);
        }),
      );
    }

    await Future.wait(futures);
  }
}

