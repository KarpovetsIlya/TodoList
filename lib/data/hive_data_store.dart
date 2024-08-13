import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/model/task.dart';
import 'package:flutter/foundation.dart';

class HiveDataStore {
  static const boxName = 'taskBox';
  final Box<Task> box = Hive.box<Task>(boxName);

  Future<void> addTask(todo, {required Task task}) async {
    await box.put(task.id, task);
  }

  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
