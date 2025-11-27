import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/app_settings.dart';
import 'models/dice_state.dart';
import 'services/dice_animation_service.dart';
import 'services/dice_roller_service.dart';
import 'utils/pwa_helper.dart';
import 'widgets/dice_grid.dart';
import 'widgets/dice_numbers_display.dart';
import 'widgets/roll_button.dart';
import 'widgets/settings_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void updateThemeMode(ThemeMode mode) {
    if (mounted) {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: DiceViewerPage(
        onThemeModeChanged: updateThemeMode,
        initialThemeMode: _themeMode,
      ),
    );
  }
}

class DiceViewerPage extends StatefulWidget {
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final ThemeMode initialThemeMode;

  const DiceViewerPage({
    super.key,
    this.onThemeModeChanged,
    this.initialThemeMode = ThemeMode.system,
  });

  @override
  State<DiceViewerPage> createState() => _DiceViewerPageState();
}

class _DiceViewerPageState extends State<DiceViewerPage>
    with TickerProviderStateMixin {
  int _numberOfDice = 2;
  late DiceState _diceState;
  late AppSettings _settings;
  late DiceAnimationService _animationService;
  late DiceRollerService _rollerService;

  @override
  void initState() {
    super.initState();
    _diceState = DiceState.initial(_numberOfDice);
    _settings = AppSettings(themeMode: widget.initialThemeMode);
    _initializeServices();
  }

  void _initializeServices() {
    _animationService = DiceAnimationService();
    _animationService.initialize(
      _numberOfDice,
      this,
      onRollingValueUpdate: (index, value) {
        if (index < _diceState.rollingValues.length) {
          setState(() {
            _diceState = _diceState.copyWith(
              rollingValues: [
                ..._diceState.rollingValues.sublist(0, index),
                value,
                ..._diceState.rollingValues.sublist(index + 1),
              ],
            );
          });
        }
      },
    );

    _rollerService = DiceRollerService(
      _animationService,
      onStateUpdate: (newState) {
        if (mounted) {
          setState(() {
            _diceState = newState;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _animationService.dispose();
    super.dispose();
  }

  void _updateDiceCount(int count) {
    setState(() {
      _numberOfDice = count;
      _diceState = DiceState.initial(count);
      _initializeServices();
    });
  }

  void _updateSettings(AppSettings newSettings) {
    final previousThemeMode = _settings.themeMode;
    setState(() {
      _settings = newSettings;
    });
    // Update theme mode in parent if it changed
    if (newSettings.themeMode != previousThemeMode) {
      widget.onThemeModeChanged?.call(newSettings.themeMode);
    }
  }

  Future<void> _rollDice() async {
    await _rollerService.rollDice(_diceState);
  }

  void _toggleReveal() {
    if (!_settings.hideNumbers) return;
    if (!_settings.isUnlimitedReveals &&
        _diceState.revealCountUsed >= _settings.maxRevealCount) return;

    setState(() {
      final wasRevealed = _diceState.isRevealed;
      _diceState = _diceState.copyWith(
        isRevealed: !wasRevealed,
        // Increment reveal count when hiding (after being revealed)
        revealCountUsed: wasRevealed
            ? _diceState.revealCountUsed + 1
            : _diceState.revealCountUsed,
      );
    });
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SettingsDialog(
        settings: _settings,
        numberOfDice: _numberOfDice,
        onSettingsChanged: _updateSettings,
        onDiceCountChanged: _updateDiceCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Dice Up'),
        actions: [
          IconButton(
            icon: Icon(
              _settings.hideNumbers ? Icons.visibility : Icons.visibility_off,
            ),
            tooltip: _settings.hideNumbers ? 'Show Numbers' : 'Hide Numbers',
            onPressed: () {
              _updateSettings(
                _settings.copyWith(hideNumbers: !_settings.hideNumbers),
              );
            },
          ),
          if (kIsWeb)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Install App',
              onPressed: () => showInstallPrompt(),
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DiceGrid(
                      diceState: _diceState,
                      settings: _settings,
                      animationService: _animationService,
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 56,
                      child: DiceNumbersDisplay(
                        diceState: _diceState,
                        settings: _settings,
                        onToggleReveal: _toggleReveal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: 'Settings',
                        onPressed: () => _showSettingsDialog(context),
                      ),
                    ],
                  ),
                  RollButton(
                    isRolling: _diceState.isAnyRolling,
                    onRoll: _rollDice,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
