import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List tasks;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const CustomAppBar({
    super.key,
    required this.tasks,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      toolbarHeight: 150,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Container(
        alignment: Alignment.bottomLeft,
        height: 150,
        padding: const EdgeInsets.only(left: 50, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Мои дела',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.textTheme.headlineSmall?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  'Выполнено — ${widget.tasks.where((task) => task.isDone).length}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onToggleVisibility,
                  icon: Icon(
                    widget.isVisible ? Icons.visibility : Icons.visibility_off,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
