import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import 'color_picker.dart';

class SettingsDialog extends StatefulWidget {
  final AppSettings settings;
  final int numberOfDice;
  final ValueChanged<AppSettings> onSettingsChanged;
  final ValueChanged<int> onDiceCountChanged;

  const SettingsDialog({
    super.key,
    required this.settings,
    required this.numberOfDice,
    required this.onSettingsChanged,
    required this.onDiceCountChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late AppSettings _currentSettings;
  late int _currentNumberOfDice;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
    _currentNumberOfDice = widget.numberOfDice;
  }

  @override
  void didUpdateWidget(SettingsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settings != oldWidget.settings) {
      _currentSettings = widget.settings;
    }
    if (widget.numberOfDice != oldWidget.numberOfDice) {
      _currentNumberOfDice = widget.numberOfDice;
    }
  }

  final List<Color> diceColorOptions = [
    Colors.white,
    Colors.red.shade400,
    Colors.blue.shade400,
    Colors.green.shade400,
    Colors.yellow.shade400,
    Colors.purple.shade400,
    Colors.orange.shade400,
    Colors.pink.shade400,
  ];


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Fixed drag handle at top
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: _buildDragHandle(),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 24),
                    _buildGameSettingsSection(context),
                    const SizedBox(height: 20),
                    _buildAppearanceSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Settings',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildGameSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('GAME'),
        _buildSectionContainer([
          _buildNumberDiceTile(context),
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.visibility_off,
            title: 'Hide Dice Numbers',
            value: _currentSettings.hideNumbers,
            onChanged: (value) {
              setState(() {
                _currentSettings = _currentSettings.copyWith(hideNumbers: value);
              });
              widget.onSettingsChanged(_currentSettings);
            },
          ),
          if (_currentSettings.hideNumbers) ...[
            _buildMaxRevealCountTile(),
          ],
          _buildDivider(),
          _buildSettingTile(
            icon: Icons.calculate,
            title: 'Show Total Sum',
            value: _currentSettings.showTotalSum,
            onChanged: (value) {
              setState(() {
                _currentSettings = _currentSettings.copyWith(showTotalSum: value);
              });
              widget.onSettingsChanged(_currentSettings);
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildMaxRevealCountTile() {
    return Padding(
      padding: const EdgeInsets.only(left: 54, right: 16, top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Max Reveal Count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Numbered options (1-5)
              ...List.generate(5, (i) {
                final count = i + 1;
                return _buildRevealCountButton(
                  label: '$count',
                  value: count,
                  isSelected: count == _currentSettings.maxRevealCount,
                );
              }),
              // Unlimited option (last)
              _buildRevealCountButton(
                label: 'Unlimited',
                value: -1,
                isSelected: _currentSettings.maxRevealCount == -1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevealCountButton({
    required String label,
    required int value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSettings = _currentSettings.copyWith(
            maxRevealCount: value,
          );
        });
        widget.onSettingsChanged(_currentSettings);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('APPEARANCE'),
        _buildSectionContainer([
          _buildColorSelectorTile(
            icon: Icons.palette,
            title: 'Dice Color',
            colors: diceColorOptions,
            selectedColor: _currentSettings.diceColor,
            onColorSelected: (color) {
              setState(() {
                _currentSettings = _currentSettings.copyWith(diceColor: color);
              });
              widget.onSettingsChanged(_currentSettings);
            },
          ),
          _buildDivider(),
          _buildThemeModeTile(),
        ]),
      ],
    );
  }

  Widget _buildNumberDiceTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.casino,
                size: 22,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Number of Dice',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(6, (i) {
                final count = i + 1;
                final isSelected = count == _currentNumberOfDice;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentNumberOfDice = count;
                    });
                    widget.onDiceCountChanged(count);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          _buildSleekSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildColorSelectorTile({
    required IconData icon,
    required String title,
    required List<Color> colors,
    required Color selectedColor,
    required ValueChanged<Color> onColorSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: ColorPicker(
              colors: colors,
              selectedColor: selectedColor,
              onColorSelected: onColorSelected,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 54,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
    );
  }

  Widget _buildThemeModeTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6,
                size: 22,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 16),
              Text(
                'App Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildThemeOption(
                  'Light',
                  ThemeMode.light,
                  Icons.light_mode,
                ),
                _buildThemeOption(
                  'Dark',
                  ThemeMode.dark,
                  Icons.dark_mode,
                ),
                _buildThemeOption(
                  'System',
                  ThemeMode.system,
                  Icons.brightness_auto,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, ThemeMode mode, IconData icon) {
    final isSelected = _currentSettings.themeMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSettings = _currentSettings.copyWith(themeMode: mode);
        });
        widget.onSettingsChanged(_currentSettings);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleekSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 22 : 2,
              top: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

