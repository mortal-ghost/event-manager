import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/groups.dart';
import '../services/tasks.dart';
import '../utilities/colors.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);
  static const String routeName = '/tasks';

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topPadding = 0;
  bool isDrawerOpen = false;
  late Group currentCat;

  final Group allTasksGroup = Group(
    id: '0',
    title: "All Tasks",
    icon: Icons.today_outlined,
    color: kWhite,
  );

  @override
  void initState() {
    super.initState();
    currentCat = allTasksGroup;
  }

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);

    return Expanded(
      child: Row(

      ),
    );
  }
}
