import 'package:event_manager/screens/home_screen.dart';
import 'package:event_manager/screens/login.dart';
import 'package:event_manager/screens/sign_up.dart';
import 'package:event_manager/screens/splash.dart';
import 'package:event_manager/services/authentication.dart';
import 'package:event_manager/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (_) => Tasks(),
        ),
      ],
      child: MaterialApp(
        title: 'Event Manager',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          Login.routeName: (ctx) => const Login(),
          SignUp.routeName: (ctx) => const SignUp(),
        },
      ),
    );
  }
}

