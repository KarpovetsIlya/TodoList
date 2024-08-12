import 'package:flutter/material.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/pages/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  Task? _task;

  Future<void> _navigateToTaskPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskPage()),
    );

    if (result != null) {
      setState(() {
        _task = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (_task != null) _buildTaskItem(),
                _buildTextField(),
              ],
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
              onPressed: _navigateToTaskPage,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
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
                const Text(
                  'Выполенно — 1',
                  style: TextStyle(
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

  Widget _buildTaskItem() {
    return Row(
      children: [
        const Checkbox(
          tristate: true,
          onChanged: null,
          value: null,
        ),
        Text(
          _task?.title ?? '',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return const Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Что-то надо сделать...',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
