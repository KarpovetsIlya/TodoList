import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/services/database_service.dart';

const List<String> list = <String>['Низкий', 'Средний', 'Высокий'];

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String dropdownValue = list.first;
  DateTime date = DateTime.now();
  late var formattedDate;
  late TextEditingController _titleController;
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = Task(
        id: 0,
        title: '',
        importance: dropdownValue,
        deadline: date,
        isDone: false);
    _titleController = TextEditingController(text: _currentTask.title);
    dropdownValue = _currentTask.importance;
    date = _currentTask.deadline;
    formattedDate = DateFormat('d MMMM yyyy').format(date);
  }

  final DatabaseService db = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              _currentTask = _currentTask.copyWith(
                title: _titleController.text,
                importance: dropdownValue,
                deadline: date,
              );
              db.createTask(_currentTask);
              Navigator.pop(context, _currentTask);
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
              child: TextField(
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Новая задача',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Важность',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    underline: Container(
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                    indent: 5,
                    endIndent: 5,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Сделать до',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                        locale: const Locale('ru', 'RU'),
                      ).then(
                        (selectedDate) {
                          if (selectedDate != null) {
                            setState(
                              () {
                                date = selectedDate;
                                formattedDate =
                                    DateFormat('d MMMM yyyy', 'ru_RU')
                                        .format(selectedDate);
                              },
                            );
                          }
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Text(formattedDate),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                    indent: 5,
                    endIndent: 5,
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: const Text(
                      'Удалить',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.all(0),
                    ),
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
