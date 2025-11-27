import 'package:flutter/material.dart';

class RollButton extends StatelessWidget {
  final bool isRolling;
  final VoidCallback onRoll;

  const RollButton({
    super.key,
    required this.isRolling,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: isRolling ? null : onRoll,
      icon: isRolling
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.casino),
      label: Text(isRolling ? 'Rolling...' : 'Roll Dice'),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        textStyle: const TextStyle(fontSize: 12),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        overlayColor: Colors.transparent,
      ),
    );
  }
}
