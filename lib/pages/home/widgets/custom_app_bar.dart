import 'package:flutter/material.dart';

AppBar buildAppBar(List tasks) {
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
                'Выполенно — ${tasks.where((task) => task.isDone).length}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Добавьте действие при нажатии на кнопку
                },
                icon: const Icon(Icons.visibility, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
