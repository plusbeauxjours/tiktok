import 'package:flutter/cupertino.dart';

class BirthdayDatePicker extends StatelessWidget {
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final void Function(DateTime) onDateTimeChanged;

  const BirthdayDatePicker({
    Key? key,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: initialDateTime,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }
}
