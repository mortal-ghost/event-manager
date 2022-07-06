import 'package:flutter/material.dart';
import 'dart:convert';
import 'groups.dart';

class Task {
  late final String id;
  late final String title;
  late final DateTime date;
  late final TimeOfDay startTime;
  late final TimeOfDay endTime;
  final Group category;
  late final String reminder;

  Task(
      {required this.id,
      required this.title,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.category,
      required this.reminder});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime.toFormattedString(),
      'endTime': endTime.toFormattedString(),
      'category': json.encode({
        'id': category.id,
        'title': category.title,
        'color': category.color.value,
      }),
      'reminder': reminder,
    };
  }
  
  Task addId(String id) {
    return Task(
        id: id,
        title: title,
        date: date,
        startTime: startTime,
        endTime: endTime,
        category: category,
        reminder: reminder);
  }

  factory Task.fromMap(Map<String, dynamic> data) {
    final startTimeData =
        json.decode(data['startTime']) as Map<String, dynamic>;
    final endTimeData = json.decode(data['endTime']) as Map<String, dynamic>;
    final categoryData = json.decode(data['category']);

    return Task(
        id: data['id'],
        title: data['title'],
        date: DateTime.parse(data['date']),
        startTime: TimeOfDay(
          hour: startTimeData['hour'],
          minute: startTimeData['minute'],
        ),
        endTime: TimeOfDay(
          hour: endTimeData['hour'],
          minute: endTimeData['minute'],
        ),
        category: Group.fromMap(categoryData),
        reminder: data['reminder']);
  }
}

extension PassTime on TimeOfDay {
  String toFormattedString() {
    return json.encode({
      'hour': hour,
      'minute': minute,
    });
  }
}