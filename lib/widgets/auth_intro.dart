import 'package:flutter/material.dart';
import '../utilities//fonts.dart';
import '../utilities//size_config.dart';

class AuthScreenIntro extends StatelessWidget {
  const AuthScreenIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalBlock * 5
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.08,
            ),
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(175, 240, 192, 1),
              radius: 28,
              child: Text(
                "E",
                style: Fonts.bold.copyWith(
                  fontSize: SizeConfig.horizontalBlock * 8,
                  color: Colors.blue[800],
                )
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Text(
              "Let's get started",
              style: Fonts.bold.copyWith(
                fontSize: SizeConfig.horizontalBlock * 9,
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Text(
              "Plan events with ease",
              style: Fonts.medium.copyWith(
                fontSize: SizeConfig.horizontalBlock * 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
