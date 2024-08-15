import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onAdd;

  const CustomBottomBar({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
