import 'package:todolist/model/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final Task task;
  DeleteTask(this.task);
}
