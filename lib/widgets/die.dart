import 'package:flutter/material.dart';
import '../services/dot_pattern_service.dart';

class Die extends StatelessWidget {
  final int value;
  final Color color;
  final bool hideValue;

  const Die({
    super.key,
    required this.value,
    this.color = Colors.white,
    this.hideValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: hideValue
          ? Center(
              child: Icon(
                Icons.question_mark,
                size: 28,
                color: color.computeLuminance() > 0.5
                    ? Colors.black87
                    : Colors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: DotPatternService.buildDots(value, _getDotColor()),
            ),
    );
  }

  Color _getDotColor() {
    return color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}

