import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    required this.controller,
    required this.hintText,
    super.key,
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
  });
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Search field',
        hint: hintText,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Semantics(
              label: 'Search icon',
              child: const Icon(Icons.search),
            ),
            suffixIcon: showClearButton && controller.text.isNotEmpty
                ? Semantics(
                    label: 'Clear search',
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        onClear?.call();
                      },
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      );
}
