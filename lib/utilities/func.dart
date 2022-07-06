import 'package:flutter/material.dart';

String timeMode(time) {
  if (time == null) {
    return "";
  }

  if (time.periodOffset == 0) {
    return "AM";
  } else {
    return "PM";
  }
}

String minutes(time) {
  if (time == null) {
    return "";
  }
  if (time.minute < 10) {
    return "0${time.minute}";
  } else {
    return "${time.minute}";
  }
}

String hours(time) {
  if (time == null) {
    return "";
  }
  if (time.hour == time.periodOffset) {
    return '12';
  }
  return "${time.hour - time.periodOffset}";
}

showError(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
          'Error!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
      ),
      content: Text(
        error
      ),
      actions: [
        TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'OK',
        ),
        )
      ],
    ),
  );
}