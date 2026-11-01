import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';

/// Displays a brief iOS-style floating banner toast at the top of the screen.
void showCupertinoToast(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  final colorScheme = context.colorScheme;
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (overlayContext) {
      final topPadding = MediaQuery.paddingOf(overlayContext).top;
      return Positioned(
        top: topPadding + 12,
        left: 20,
        right: 20,
        child: IgnorePointer(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, -16 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? colorScheme.error : colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError
                        ? CupertinoIcons.exclamationmark_circle_fill
                        : CupertinoIcons.checkmark_circle_fill,
                    size: 18,
                    color: isError
                        ? colorScheme.onError
                        : colorScheme.onInverseSurface,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: context.textTheme.bodyMedium.copyWith(
                        color: isError
                            ? colorScheme.onError
                            : colorScheme.onInverseSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
  Timer(duration, () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

