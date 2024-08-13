import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/data/hive_data_store.dart';
import 'package:todolist/model/task.dart';
import 'package:uuid/uuid.dart';

const List<String> list = <String>['Низкий', 'Средний', 'Высокий'];

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({super.key, this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late String dropdownValue;
  late DateTime date;
  late String formattedDate;
  late TextEditingController _titleController;
  final HiveDataStore _hiveDataStore = HiveDataStore();
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
    formattedDate = DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var todo = _currentTask;
              todo.title = _titleController.text;
              todo.importance = dropdownValue;
              todo.deadline = date;
              if (widget.task == null) {
                await _hiveDataStore.addTask(todo, task: todo);
              } else {
                await _hiveDataStore.updateTask(task: todo);
              }
              Navigator.pop(context, todo);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
