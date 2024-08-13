import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.importance,
    required this.deadline,
    required this.isDone,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String importance;
  @HiveField(3)
  DateTime deadline;
  @HiveField(4)
  bool isDone;

  factory Task.create({
    required String? title,
    required String? importance,
    DateTime? deadline,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title ?? "",
        importance: importance ?? "",
        deadline: deadline ?? DateTime.now(),
        isDone: false,
      );

  @override
  String toString() {
    return 'Task{id: $id, title: $title, importance: $importance, deadline: $deadline, isDone: $isDone}';
  }
}
