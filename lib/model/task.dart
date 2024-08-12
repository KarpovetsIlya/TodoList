// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

const String tableName = 'tasks';

const String idColumn = '_id';
const String titleColumn = 'title';
const String importanceColumn = 'importance';
const String deadlineColumn = 'deadline';
const String isDoneColumn = 'isDone';

const List<String> taskColumns = [
  idColumn,
  titleColumn,
  importanceColumn,
  deadlineColumn,
  isDoneColumn,
];

class Task {
  final int id;
  final String title;
  final String importance;
  final DateTime deadline;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.importance,
    required this.deadline,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      idColumn: id,
      titleColumn: title,
      importanceColumn: importance,
      deadlineColumn: deadline.toIso8601String(),
      isDoneColumn: isDone ? 1 : 0, // Convert bool to int
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map[idColumn] as int,
      title: map[titleColumn] as String,
      importance: map[importanceColumn] as String,
      deadline: DateTime.parse(map[deadlineColumn] as String),
      isDone: (map[isDoneColumn] as int) == 1, // Convert int to bool
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? importance,
    DateTime? deadline,
    bool? isDone,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        importance: importance ?? this.importance,
        deadline: deadline ?? this.deadline,
        isDone: isDone ?? this.isDone,
      );

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
