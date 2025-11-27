import 'package:flutter/material.dart';
import '../models/dice_state.dart';
import '../models/app_settings.dart';

class DiceNumbersDisplay extends StatefulWidget {
  final DiceState diceState;
  final AppSettings settings;
  final VoidCallback? onToggleReveal;

  const DiceNumbersDisplay({
    super.key,
    required this.diceState,
    required this.settings,
    this.onToggleReveal,
  });

  @override
  State<DiceNumbersDisplay> createState() => _DiceNumbersDisplayState();
}

class _DiceNumbersDisplayState extends State<DiceNumbersDisplay> {
  @override
  Widget build(BuildContext context) {
    // Hide widget if reveals are exhausted (and not unlimited)
    if (widget.settings.hideNumbers &&
        !widget.settings.isUnlimitedReveals &&
        widget.diceState.revealCountUsed >= widget.settings.maxRevealCount) {
      return const SizedBox.shrink();
    }

    final revealsLeft = widget.settings.isUnlimitedReveals
        ? null
        : widget.settings.maxRevealCount - widget.diceState.revealCountUsed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 32,
            child: Center(
              child: _buildContent(context),
            ),
          ),
          // Info text (always visible when hideNumbers is enabled)
          if (widget.settings.hideNumbers)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                revealsLeft == null
                    ? 'Unlimited reveals'
                    : 'Reveals left: $revealsLeft',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // If hideNumbers is disabled, just show numbers
    if (!widget.settings.hideNumbers) {
      return _buildNumbersRow(context);
    }

    // If hideNumbers is enabled, show overlay with transparent background when hidden
    // Show numbers when revealed
    final isRevealed = widget.diceState.isRevealed;

    return GestureDetector(
      onTap: widget.onToggleReveal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color:
              isRevealed ? Colors.transparent : Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: isRevealed
            ? _buildNumbersRow(context)
            : const Text(
                'Tap to show/hide',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Color _getNumbersColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = Theme.of(context).colorScheme.surface;

    // Use theme brightness to determine appropriate text color
    // For light theme: use darker, muted color
    // For dark theme: use lighter, muted color
    if (brightness == Brightness.light) {
      // Light theme - use darker shade that's visible but subtle
      final darkerColor = Color.lerp(bgColor, Colors.black, 0.4);
      // Ensure good contrast while maintaining subtlety
      if (darkerColor != null) {
        final contrastLuminance = darkerColor.computeLuminance();
        // If contrast is too low, darken further
        if (contrastLuminance > 0.3) {
          return Color.lerp(darkerColor, Colors.black, 0.2) ?? Colors.black54;
        }
        return darkerColor;
      }
      return Colors.black54;
    } else {
      // Dark theme - use lighter shade that's visible but subtle
      final lighterColor = Color.lerp(bgColor, Colors.white, 0.4);
      // Ensure good contrast while maintaining subtlety
      if (lighterColor != null) {
        final contrastLuminance = lighterColor.computeLuminance();
        // If contrast is too low, lighten further
        if (contrastLuminance < 0.7) {
          return Color.lerp(lighterColor, Colors.white, 0.2) ??
              Colors.white.withOpacity(0.6);
        }
        return lighterColor;
      }
      return Colors.white.withOpacity(0.6);
    }
  }

  Widget _buildNumbersRow(BuildContext context) {
    final numbersColor = _getNumbersColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dice numbers
        ...widget.diceState.currentValues.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right:
                  index < widget.diceState.currentValues.length - 1 ? 8.0 : 0,
            ),
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: numbersColor,
              ),
            ),
          );
        }),
        // Total sum (if enabled)
        if (widget.settings.showTotalSum) ...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '= ${widget.diceState.total}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: numbersColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
