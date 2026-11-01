import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({super.key});

  String _getTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning! 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon! 👋';
    } else {
      return 'Good Evening! 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Text(
      _getTimeBasedGreeting(),
      style: context.textTheme.bodyMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
