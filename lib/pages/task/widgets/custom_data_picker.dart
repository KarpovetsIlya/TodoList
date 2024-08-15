import 'package:flutter/material.dart';

class CustomDataPicker extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;
  final String formattedDate;

  const CustomDataPicker(
      {super.key,
      required this.date,
      required this.onDateSelected,
      required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Сделать до',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        TextButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              locale: const Locale('ru', 'RU'),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.all(0),
          ),
          child: Text(formattedDate),
        ),
      ],
    );
  }
}
