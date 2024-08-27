import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todolist/bloc/task_event.dart';
import 'package:todolist/bloc/task_state.dart';
import 'package:todolist/data/task_data_store.dart';
import 'package:todolist/model/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final HiveDataStore _hiveDataStore = HiveDataStore();

  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    final LoadTasks event,
    final Emitter<TaskState> emit,
  ) async {
    emit(TaskLoadInProgress());
    try {
      await Hive.openBox<Task>('taskBox');
      final tasks = _hiveDataStore.box.values.toList().cast<Task>();
      emit(TaskLoadSuccess(tasks));
    } catch (_) {
      emit(TaskLoadFailure());
    }
  }

  Future<void> _onAddTask(
    final AddTask event,
    final Emitter<TaskState> emit,
  ) async {
    try {
      await _hiveDataStore.addTask(task: event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskLoadFailure());
    }
  }

  Future<void> _onUpdateTask(
    final UpdateTask event,
    final Emitter<TaskState> emit,
  ) async {
    try {
      await _hiveDataStore.updateTask(task: event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskLoadFailure());
    }
  }

  Future<void> _onDeleteTask(
    final DeleteTask event,
    final Emitter<TaskState> emit,
  ) async {
    try {
      await _hiveDataStore.deleteTask(task: event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskLoadFailure());
    }
  }
}
