import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';
import 'package:shimmer/shimmer.dart';

/// A simple shimmer placeholder widget using the shimmer package
class ShimmerPlaceholder extends StatelessWidget {
  /// Creates a [ShimmerPlaceholder].
  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
  });

  /// Optional fixed width; if `null` the widget fills available space.
  final double? width;

  /// Height of the placeholder. Defaults to 56.
  final double height;

  /// Corner radius of the placeholder rectangle. Defaults to 12.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      highlightColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.1,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: colorScheme.surfaceContainerHighest,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: borderRadius,
              cornerSmoothing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

/// AI Processing Indicator - shows at the top of the form.
/// Note: This widget is conditionally rendered when processing.
class AIProcessingIndicator extends StatelessWidget {
  /// Creates an [AIProcessingIndicator].
  const AIProcessingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: colorScheme.primaryContainer,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CupertinoActivityIndicator(color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI is analyzing your receipt',
                  style: context.textTheme.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Fields will auto-fill in a moment...',
                  style: context.textTheme.bodySmall.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
