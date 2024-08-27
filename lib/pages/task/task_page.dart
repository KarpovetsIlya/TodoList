import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/bloc/task_bloc.dart';
import 'package:todolist/bloc/task_event.dart';
import 'package:todolist/data/task_data_store.dart';
import 'package:todolist/main.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/pages/task/widgets/custom_data_picker.dart';
import 'package:todolist/pages/task/widgets/custom_dropdown_button.dart';
import 'package:todolist/pages/task/widgets/custom_title_input.dart';
import 'package:uuid/uuid.dart';

const List<String> list = <String>['Низкий', 'Нет', 'Высокий'];

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
        importance: 'Нет',
        deadline: DateTime.now(),
        isDone: false,
      );
      dropdownValue = _currentTask.importance;
      date = _currentTask.deadline;
      _titleController = TextEditingController();
    }

    formattedDate = DateFormat('d MMMM yyyy', 'ru_RU').format(date);
  }

  void _setImportance(final String value) {
    setState(() {
      dropdownValue = value;
    });
  }

  void _setDeadline(final DateTime value) {
    setState(() {
      date = value;
      formattedDate = DateFormat('d MMMM yyyy', 'ru_RU').format(value);
    });
  }

  Future<void> _saveTask() async {
    _currentTask
      ..title = _titleController.text
      ..importance = dropdownValue
      ..deadline = date;

    if (widget.task == null) {
      context.read<TaskBloc>().add(AddTask(_currentTask));
    } else {
      context.read<TaskBloc>().add(UpdateTask(_currentTask));
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.iconTheme.color),
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
            child: Text(
              'Сохранить',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.iconTheme.color,
              ),
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
                    color: theme.dividerColor,
                    thickness: 1,
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
                    color: theme.dividerColor,
                    thickness: 1,
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
