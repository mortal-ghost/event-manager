import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/groups.dart';
import '../models/task.dart';

class Tasks with ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  List<Group> _categories = [];
  List<Task> _tasks = [];

  List<Group> get categories {
    return [..._categories];
  }

  List<Task> get tasks {
    return [..._tasks];
  }

  List<Task> getTasksByCategory(Group category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTodayTasks() {
    return _tasks.where((task) => task.date.isDateSame(selectedDate)).toList();
  }

  void addCategory(Group group) {
    if (!_categories.contains(group)) {
      _categories.add(group);
    }
  }

  void deleteCategory(Group group) {
    _tasks.removeWhere((task) => task.category == group);
    _categories.remove(group);
  }

  void addTask(Task task) {
    if (!_tasks.contains(task)) {
      _tasks.add(task);
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
  }

  void updateTask(Task task, Task newTask) {
    _tasks[_tasks.indexOf(task)] = newTask;
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
  }
    
  void fetchAndSetTasks() async {
    _tasks.clear();
    _categories.clear();
    
    final database = FirebaseFirestore.instance.collection('Users');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    
    if (uid != null) {
      database.doc(uid).collection('Tasks').get().then((value) {
        value.docs.forEach((elt) {
          final task = Task.fromMap(elt.data());
          _tasks.add(task);
        });
      }); 
      
      database.doc(uid).collection('Categories').get().then((value) {
        value.docs.forEach((elt) {
          final category = Group.fromMap(elt.data());
          _categories.add(category);
        });
      });
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isDateSame(DateTime date) {
    return year == date.year && month == date.month &&
        day == date.day;
  }
  
  bool isDateAfter(DateTime date) {
    return year > date.year ||
        (year == date.year && month > date.month) ||
        (year == date.year && month == date.month && day > date.day);
  }
  
  bool isDateBefore(DateTime date) {
    return year < date.year ||
        (year == date.year && month < date.month) ||
        (year == date.year && month == date.month && day < date.day);
  }

}