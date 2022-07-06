import 'dart:async';
import 'package:event_manager/utilities//size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../animations/sprite_painter.dart';
import '../utilities//colors.dart';
import '../services/tasks.dart';
import 'calendar_screen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override

  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3)
    ).then((_){
      _scaleController.forward();
    });

    _controller = AnimationController(
      vsync: this,
    );

    _startAnimation();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        Timer(
          const Duration(milliseconds: 500),
            () => _scaleController.reset(),
        );

        User? user= FirebaseAuth.instance.currentUser;

        if (user != null) {
          Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();

          Navigator.pushAndRemoveUntil(
              context,
              AnimatingRoute(
                route: const CalendarScreen()
              ), (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              AnimatingRoute(
                route: const Login()
              ), (route) => false,
          );
        }
      }
    });

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 10.5,
    ).animate(_scaleController);
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: darkBlue,
      body: Stack(
        children: [
          Center(
            child: CustomPaint(
              painter: SpritePainter(_controller),
              child: Container(),
            ),
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: const Color.fromRGBO(175, 240, 192, 1),
              radius: SizeConfig.horizontalBlock * 25,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "E",
                      style: GoogleFonts.lobster(
                        fontSize: SizeConfig.horizontalBlock * 35,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (c, _) => Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(175, 240, 192, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatingRoute extends PageRouteBuilder {
  late final Widget? page;
  late final Widget? route;

  AnimatingRoute({this.page, this.route}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page!,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: route,
    ),
  );
}
