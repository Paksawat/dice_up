import 'package:flutter/material.dart';
import '../models/dice_state.dart';
import '../models/app_settings.dart';
import '../services/dice_animation_service.dart';
import 'die.dart';

class DiceGrid extends StatelessWidget {
  final DiceState diceState;
  final AppSettings settings;
  final DiceAnimationService animationService;

  static const double _diceSize = 60.0;
  static const double _spacing = 25.0;

  const DiceGrid({
    super.key,
    required this.diceState,
    required this.settings,
    required this.animationService,
  });

  @override
  Widget build(BuildContext context) {
    final numberOfDice = diceState.currentValues.length;

    return Center(
      child: _buildLayout(numberOfDice),
    );
  }

  Widget _buildLayout(int numberOfDice) {
    final diceWidgets = List.generate(
      numberOfDice,
      (index) => SizedBox(
        width: _diceSize,
        height: _diceSize,
        child: _buildSingleDie(index),
      ),
    );

    switch (numberOfDice) {
      case 1:
        // 1 dice: center of the screen
        return diceWidgets[0];

      case 2:
        // 2 dice: one column (vertical stack)
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            diceWidgets.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < diceWidgets.length - 1 ? _spacing : 0,
              ),
              child: diceWidgets[index],
            ),
          ),
        );

      case 3:
        // 3 dice: one row (horizontal)
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            diceWidgets.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                right: index < diceWidgets.length - 1 ? _spacing : 0,
              ),
              child: diceWidgets[index],
            ),
          ),
        );

      case 4:
        // 4 dice: 2 columns, 2 rows (2x2 grid)
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                diceWidgets[0],
                Padding(
                  padding: const EdgeInsets.only(left: _spacing),
                  child: diceWidgets[1],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: _spacing),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  diceWidgets[2],
                  Padding(
                    padding: const EdgeInsets.only(left: _spacing),
                    child: diceWidgets[3],
                  ),
                ],
              ),
            ),
          ],
        );

      case 5:
        // 5 dice: 2 rows - 3 dice on first row, 2 dice on second row
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                diceWidgets[0],
                Padding(
                  padding: const EdgeInsets.only(left: _spacing),
                  child: diceWidgets[1],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: _spacing),
                  child: diceWidgets[2],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: _spacing),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  diceWidgets[3],
                  Padding(
                    padding: const EdgeInsets.only(left: _spacing),
                    child: diceWidgets[4],
                  ),
                ],
              ),
            ),
          ],
        );

      case 6:
        // 6 dice: 2 rows - 3 dice on each row
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                diceWidgets[0],
                Padding(
                  padding: const EdgeInsets.only(left: _spacing),
                  child: diceWidgets[1],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: _spacing),
                  child: diceWidgets[2],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: _spacing),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  diceWidgets[3],
                  Padding(
                    padding: const EdgeInsets.only(left: _spacing),
                    child: diceWidgets[4],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: _spacing),
                    child: diceWidgets[5],
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        // 7+ dice: wrap layout (fallback behavior)
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: _spacing,
          runSpacing: _spacing,
          children: diceWidgets,
        );
    }
  }

  Widget _buildSingleDie(int index) {
    if (animationService.controllers.isEmpty ||
        index >= animationService.controllers.length) {
      return const SizedBox();
    }

    final isRolling = diceState.isRolling[index];
    final value = isRolling
        ? diceState.rollingValues[index]
        : diceState.currentValues[index];

    return AnimatedBuilder(
      animation: animationService.rotationAnimations[index],
      builder: (context, child) {
        return Transform.rotate(
          angle:
              isRolling ? animationService.rotationAnimations[index].value : 0,
          child: Transform.scale(
            scale: isRolling ? 1.1 : 1.0,
            child: Die(
              value: value,
              color: settings.diceColor,
              hideValue: settings.hideNumbers,
            ),
          ),
        );
      },
    );
  }
}
