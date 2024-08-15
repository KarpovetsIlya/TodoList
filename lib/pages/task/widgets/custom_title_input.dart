import 'package:flutter/material.dart';

class CustomTitleInput extends StatelessWidget {
  final TextEditingController controller;

  const CustomTitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Новая задача',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
