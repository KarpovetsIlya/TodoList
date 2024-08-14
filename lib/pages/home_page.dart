import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/data/hive_data_store.dart';
import 'package:todolist/model/task.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return _buildTaskItem(task);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
              onPressed: () {
                _navigateToTaskPage(null);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 150,
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.bottomLeft,
        height: 150,
        padding: const EdgeInsets.only(left: 50, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Мои дела',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  'Выполенно — ${_tasks.where((task) => task.isDone).length}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        _hiveDataStore.deleteTask(task: task);
        setState(() {
          _tasks.remove(task);
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: task.isDone,
            onChanged: (bool? value) {
              setState(() {
                task.isDone = value ?? false;
                _hiveDataStore.updateTask(task: task);
              });
            },
          ),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                color: task.isDone ? Colors.grey : Colors.black,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _navigateToTaskPage(task);
            },
            icon: const Icon(Icons.info_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
