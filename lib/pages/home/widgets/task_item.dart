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

  @override
  Widget build(BuildContext context) {
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
          ),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                color: task.isDone ? Colors.grey : Colors.black,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
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
