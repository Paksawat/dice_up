import 'package:flutter/material.dart';

class AppSettings {
  final bool hideNumbers;
  final Color diceColor;
  final ThemeMode themeMode;
  final bool showTotalSum;
  final int maxRevealCount;

  const AppSettings({
    this.hideNumbers = false,
    this.diceColor = Colors.white,
    this.themeMode = ThemeMode.system,
    this.showTotalSum = false,
    this.maxRevealCount = 1,
  });

  bool get isUnlimitedReveals => maxRevealCount == -1;

  AppSettings copyWith({
    bool? hideNumbers,
    Color? diceColor,
    ThemeMode? themeMode,
    bool? showTotalSum,
    int? maxRevealCount,
  }) {
    return AppSettings(
      hideNumbers: hideNumbers ?? this.hideNumbers,
      diceColor: diceColor ?? this.diceColor,
      themeMode: themeMode ?? this.themeMode,
      showTotalSum: showTotalSum ?? this.showTotalSum,
      maxRevealCount: maxRevealCount ?? this.maxRevealCount,
    );
  }
}

