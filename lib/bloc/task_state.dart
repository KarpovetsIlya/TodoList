import 'package:todolist/model/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;
  TaskLoadSuccess(this.tasks);
}

class TaskLoadFailure extends TaskState {}
