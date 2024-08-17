import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onAdd;

  const CustomBottomBar({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BottomAppBar(
      color: theme.bottomAppBarTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: theme.primaryColor,
            ),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
