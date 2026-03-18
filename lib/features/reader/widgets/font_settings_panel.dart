import 'package:flutter/material.dart';

class FontSettingsPanel extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final double minFontSize;
  final double maxFontSize;
  final Color? iconColor;

  const FontSettingsPanel({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
    this.minFontSize = 12,
    this.maxFontSize = 32,
    this.iconColor,
  });

  void _increaseFont() {
    if (fontSize < maxFontSize) {
      onFontSizeChanged((fontSize + 2).clamp(minFontSize, maxFontSize));
    }
  }

  void _decreaseFont() {
    if (fontSize > minFontSize) {
      onFontSizeChanged((fontSize - 2).clamp(minFontSize, maxFontSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Font Button
          IconButton(
            onPressed: _decreaseFont,
            icon: const Icon(Icons.remove),
            color: color,
            tooltip: 'Decrease font size',
            splashRadius: 24,
          ),
          // Current Font Size
          Text(
            fontSize.toStringAsFixed(0),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          // Increase Font Button
          IconButton(
            onPressed: _increaseFont,
            icon: const Icon(Icons.add),
            color: color,
            tooltip: 'Increase font size',
            splashRadius: 24,
          ),
        ],
      ),
    );
  }
}