class DiceState {
  final List<int> currentValues;
  final List<bool> isRolling;
  final List<int> rollingValues;
  final bool isRevealed;
  final int revealCountUsed;

  const DiceState({
    required this.currentValues,
    required this.isRolling,
    required this.rollingValues,
    this.isRevealed = false,
    this.revealCountUsed = 0,
  });

  DiceState.initial(int numberOfDice)
      : currentValues = List.generate(numberOfDice, (_) => 1),
        isRolling = List.generate(numberOfDice, (_) => false),
        rollingValues = List.generate(numberOfDice, (_) => 1),
        isRevealed = false,
        revealCountUsed = 0;

  DiceState copyWith({
    List<int>? currentValues,
    List<bool>? isRolling,
    List<int>? rollingValues,
    bool? isRevealed,
    int? revealCountUsed,
  }) {
    return DiceState(
      currentValues: currentValues ?? this.currentValues,
      isRolling: isRolling ?? this.isRolling,
      rollingValues: rollingValues ?? this.rollingValues,
      isRevealed: isRevealed ?? this.isRevealed,
      revealCountUsed: revealCountUsed ?? this.revealCountUsed,
    );
  }

  bool get isAnyRolling => isRolling.any((rolling) => rolling);

  int get total => currentValues.fold(0, (sum, value) => sum + value);
}
