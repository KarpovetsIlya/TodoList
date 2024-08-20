import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/data/task_data_store.dart';
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
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = _hiveDataStore.box.values.toList();
    setState(() {
      _tasks = tasks.cast<Task>();
    });
  }

  Future<void> _navigateToTaskPage(final Task? task) async {
    final updatedTask = await context.push('/taskpage', extra: task);
    if (updatedTask != null && updatedTask is Task) {
      setState(() {
        final index = _tasks.indexWhere((final t) => t.id == updatedTask.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        } else {
          _tasks.add(updatedTask);
        }
      });
      await _hiveDataStore.updateTask(task: updatedTask);
    }
  }

  Future<void> _deleteTask(final Task task) async {
    await _hiveDataStore.deleteTask(task: task);
    setState(() {
      _tasks.remove(task);
    });
  }

  Future<void> _toggleTaskCompletion(final Task task, final bool? value) async {
    task.isDone = value ?? false;
    await _hiveDataStore.updateTask(task: task);
    setState(() {});
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: CustomAppBar(
        tasks: _tasks,
        isVisible: _isVisible,
        onToggleVisibility: _toggleVisibility,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (final context, final index) {
                final task = _tasks[index];
                return _isVisible || !task.isDone
                    ? TaskItem(
                        task: task,
                        onCheckboxChanged: (final value) {
                          _toggleTaskCompletion(task, value);
                        },
                        onDelete: () {
                          _deleteTask(task);
                        },
                        onEdit: () {
                          _navigateToTaskPage(task);
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(onAdd: () {
        _navigateToTaskPage(null);
      },),
    );
}
