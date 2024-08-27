import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/model/task.dart';

class HiveDataStore {
  static const boxName = 'taskBox';
  final Box<Task> box = Hive.box<Task>(boxName);

  Future<void> addTask({required final Task task}) async {
    await box.put(task.id, task);
  }

  Future<Task?> getTask({required final String id}) async => box.get(id);

  Future<void> updateTask({required final Task task}) async {
    await task.save();
  }

  Future<void> deleteTask({required final Task task}) async {
    await task.delete();
  }

  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
