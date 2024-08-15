import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/data/hive_data_store.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/pages/home/widgets/custom_app_bar.dart';
import 'package:todolist/pages/home/widgets/custom_bottom_bar.dart';
import 'package:todolist/pages/home/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final HiveDataStore _hiveDataStore = HiveDataStore();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = _hiveDataStore.box.values.toList();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _navigateToTaskPage(Task? task) async {
    final updatedTask = await context.push('/taskpage', extra: task);
    if (updatedTask != null && updatedTask is Task) {
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        } else {
          _tasks.add(updatedTask);
        }
      });
    }
  }

  void _deleteTask(Task task) {
    _hiveDataStore.deleteTask(task: task);
    setState(() {
      _tasks.remove(task);
    });
  }

  void _toggleTaskCompletion(Task task, bool? value) {
    task.isDone = value ?? false;
    _hiveDataStore.updateTask(task: task);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(_tasks),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskItem(
                  task: task,
                  onCheckboxChanged: (value) {
                    _toggleTaskCompletion(task, value);
                  },
                  onDelete: () {
                    _deleteTask(task);
                  },
                  onEdit: () {
                    _navigateToTaskPage(task);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(onAdd: () {
        _navigateToTaskPage(null);
      }),
    );
  }
}
