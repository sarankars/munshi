import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key, this.selectedColor});

  final Color? selectedColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColor;

  // Predefined color palette matching original Material palette values
  static const List<Color> _colors = [
    Color(0xFFF44336), // red
    Color(0xFFFF5252), // redAccent
    Color(0xFFE91E63), // pink
    Color(0xFFFF4081), // pinkAccent
    Color(0xFF9C27B0), // purple
    Color(0xFFE040FB), // purpleAccent
    Color(0xFF673AB7), // deepPurple
    Color(0xFF7C4DFF), // deepPurpleAccent
    Color(0xFF3F51B5), // indigo
    Color(0xFF536DFE), // indigoAccent
    Color(0xFF2196F3), // blue
    Color(0xFF448AFF), // blueAccent
    Color(0xFF03A9F4), // lightBlue
    Color(0xFF40C4FF), // lightBlueAccent
    Color(0xFF00BCD4), // cyan
    Color(0xFF18FFFF), // cyanAccent
    Color(0xFF009688), // teal
    Color(0xFF64FFDA), // tealAccent
    Color(0xFF4CAF50), // green
    Color(0xFF69F0AE), // greenAccent
    Color(0xFF8BC34A), // lightGreen
    Color(0xFFB2FF59), // lightGreenAccent
    Color(0xFFCDDC39), // lime
    Color(0xFFEEFF41), // limeAccent
    Color(0xFFFFEB3B), // yellow
    Color(0xFFFFFF00), // yellowAccent
    Color(0xFFFFC107), // amber
    Color(0xFFFFD740), // amberAccent
    Color(0xFFFF9800), // orange
    Color(0xFFFFAB40), // orangeAccent
    Color(0xFFFF5722), // deepOrange
    Color(0xFFFF6E40), // deepOrangeAccent
    Color(0xFF795548), // brown
    Color(0xFF9E9E9E), // grey
    Color(0xFF607D8B), // blueGrey
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ?? const Color(0xFF2196F3);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 500),
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 0.6,
              ),
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            shadows: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Color',
                        style: context.textTheme.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),

              // Color preview
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 60,
                  decoration: ShapeDecoration(
                    color: _selectedColor,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 12,
                        cornerSmoothing: 0.6,
                      ),
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Colors grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected =
                        _selectedColor.toARGB32() == color.toARGB32();

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? CupertinoColors.white
                                : CupertinoColors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                CupertinoIcons.checkmark_alt,
                                color: CupertinoColors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton.filled(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 12,
                        cornerSmoothing: 0.6,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      onPressed: () => Navigator.of(context).pop(_selectedColor),
                      child: const Text('Select'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
