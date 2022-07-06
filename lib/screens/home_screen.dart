import 'package:event_manager/screens/tasks_screen.dart';
import 'package:event_manager/utilities/colors.dart';
import 'package:event_manager/utilities/size_config.dart';
import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topPadding = 0;
  bool isDrawerOpen = false;

  @override

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const DrawerScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(
                  xOffset, yOffset, 0
              )..scale(scaleFactor),
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  isDrawerOpen ? 40 : 0.0
                )
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, top: topPadding),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isDrawerOpen ?
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios
                            ),
                            onPressed: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                                topPadding = 0;
                              });
                            },
                          ) :
                          IconButton(
                            icon: const Icon(
                              Icons.menu
                            ),
                            onPressed: () {
                              setState(() {
                                  xOffset = SizeConfig.horizontalBlock * 70;
                                  yOffset = SizeConfig.verticalBlock * 7;
                                  scaleFactor = 0.85;
                                  isDrawerOpen = true;
                                  topPadding = 15;
                              });
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            color: matteBlack,
                            width: SizeConfig.horizontalBlock * 18,
                            height: double.infinity,
                            child: IconButton(
                              icon: Icon(
                                Icons.calendar_today_rounded,
                                color: kGrey,
                                size: SizeConfig.verticalBlock * 4,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(CalendarScreen.routeName);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const TasksScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
