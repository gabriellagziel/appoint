import 'package:flutter/material.dart';

String greetFor(DateTime now) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) return 'Good morning';
  if (hour >= 12 && hour < 17) return 'Good afternoon';
  if (hour >= 17 && hour < 22) return 'Good evening';
  return 'Good night';
}

class GreetingHeader extends StatelessWidget {
  final bool isDesktop;
  final String? firstName;
  const GreetingHeader({super.key, required this.isDesktop, this.firstName});

  @override
  Widget build(BuildContext context) {
    final greet = greetFor(DateTime.now());
    final name =
        (firstName == null || firstName!.trim().isEmpty) ? 'there' : firstName!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greet, $name',
          style: isDesktop
              ? Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700)
              : Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'What would you like to do?',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[700]),
        )
      ],
    );
  }
}
