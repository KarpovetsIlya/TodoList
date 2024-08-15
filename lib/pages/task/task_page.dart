import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/data/hive_data_store.dart';
import 'package:todolist/pages/task/widgets/custom_data_picker.dart';
import 'package:todolist/pages/task/widgets/custom_dropdown_button.dart';
import 'package:todolist/pages/task/widgets/custom_title_input.dart';
import 'package:uuid/uuid.dart';

const List<String> list = <String>['Низкий', 'Средний', 'Высокий'];

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({super.key, this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final HiveDataStore _hiveDataStore = HiveDataStore();
  late TextEditingController _titleController;
  late String dropdownValue;
  late DateTime date;
  late String formattedDate;
  late Task _currentTask;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = widget.task!;
      dropdownValue = _currentTask.importance;
      date = _currentTask.deadline;
      _titleController = TextEditingController(text: _currentTask.title);
    } else {
      _currentTask = Task(
        id: const Uuid().v1(),
        title: '',
        importance: 'Низкий',
        deadline: DateTime.now(),
        isDone: false,
      );
      dropdownValue = _currentTask.importance;
      date = _currentTask.deadline;
      _titleController = TextEditingController();
    }

    formattedDate = DateFormat('d MMMM yyyy', 'ru_RU').format(date);
  }

  void _setImportance(String value) {
    setState(() {
      dropdownValue = value;
    });
  }

  void _setDeadline(DateTime value) {
    setState(() {
      date = value;
      formattedDate = DateFormat('d MMMM yyyy', 'ru_RU').format(value);
    });
  }

  Future<void> _saveTask() async {
    _currentTask.title = _titleController.text;
    _currentTask.importance = dropdownValue;
    _currentTask.deadline = date;

    if (widget.task == null) {
      await _hiveDataStore.addTask(_currentTask, task: _currentTask);
    } else {
      await _hiveDataStore.updateTask(task: _currentTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveTask();
              context.go('/');
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: CustomTitleInput(controller: _titleController),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdownButton(
                    value: dropdownValue,
                    options: list,
                    onChanged: _setImportance,
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                    indent: 5,
                    endIndent: 5,
                  ),
                  const SizedBox(height: 20),
                  CustomDataPicker(
                    date: date,
                    onDateSelected: _setDeadline,
                    formattedDate: formattedDate,
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                    indent: 5,
                    endIndent: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
