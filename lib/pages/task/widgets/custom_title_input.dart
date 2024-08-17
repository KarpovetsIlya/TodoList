import 'package:flutter/material.dart';

class CustomTitleInput extends StatelessWidget {
  final TextEditingController controller;

  const CustomTitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Новая задача',
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: theme.dividerColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      style: theme.textTheme.bodyLarge,
    );
  }
}
