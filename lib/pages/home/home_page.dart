import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/bloc/task_bloc.dart';
import 'package:todolist/bloc/task_event.dart';
import 'package:todolist/bloc/task_state.dart';
import 'package:todolist/model/task.dart';

import 'package:todolist/pages/home/widgets/custom_bottom_bar.dart';
import 'package:todolist/pages/home/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<TaskBloc>().add(LoadTasks());
    super.initState();
  }

  Future<void> _navigateToTaskPage(
      final BuildContext context, final Task? task) async {
    final updatedTask = await context.push('/taskpage', extra: task);
    if (updatedTask != null && updatedTask is Task) {
      context.read<TaskBloc>().add(UpdateTask(updatedTask));
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TaskBloc, TaskState>(
            builder: (final context, final state) {
              if (state is TaskLoadSuccess) {
                return Text('Задачи (${state.tasks.length})');
              }
              return const Text('Задачи');
            },
          ),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (final context, final state) {
            if (state is TaskLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoadSuccess) {
              final tasks = state.tasks;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (final context, final index) {
                  final task = tasks[index];
                  return TaskItem(
                    task: task,
                    onCheckboxChanged: (final value) {
                      task.isDone = value ?? false;
                      context.read<TaskBloc>().add(UpdateTask(task));
                    },
                    onDelete: () {
                      context.read<TaskBloc>().add(DeleteTask(task));
                    },
                    onEdit: () {
                      _navigateToTaskPage(context, task);
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Не удалось загрузить задачи'));
            }
          },
        ),
        bottomNavigationBar: CustomBottomBar(
          onAdd: () {
            _navigateToTaskPage(context, null);
          },
        ),
      );
}
