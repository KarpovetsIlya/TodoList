import 'package:flutter/material.dart';
import 'package:todolist/model/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskItem({
    super.key,
    required this.task,
    this.onCheckboxChanged,
    this.onDelete,
    this.onEdit,
  });

  IconData? _getPriorityIcon() {
    switch (task.importance) {
      case 'Высокий':
        return Icons.arrow_upward;
      case 'Низкий':
        return Icons.arrow_downward;
      default:
        return null;
    }
  }

  Color _getPriorityColor() {
    switch (task.importance) {
      case 'Высокий':
        return Colors.green;
      case 'Низкий':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityIcon = _getPriorityIcon();
    final priorityColor = _getPriorityColor();

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!();
        }
      },
      child: Row(
        children: [
          Checkbox(
            value: task.isDone,
            onChanged: onCheckboxChanged,
            activeColor: Colors.green,
          ),
          if (priorityIcon != null) ...[
            Icon(
              priorityIcon,
              color: task.isDone ? Colors.grey : priorityColor,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 24,
                    color: task.isDone
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.deadline.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.info_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
