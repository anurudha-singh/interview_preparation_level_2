import 'package:flutter/cupertino.dart';
import 'package:sharpsheel/screens/animated_container.dart';
import 'package:sharpsheel/screens/fifth_screen.dart';
import 'package:sharpsheel/screens/first_screen.dart';
import 'package:sharpsheel/screens/flutter_testing_guide.dart';
import 'package:sharpsheel/screens/fourth_screen.dart';
import 'package:sharpsheel/screens/list_generators.dart';
import 'package:sharpsheel/screens/my_home_page.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/seventh_screen.dart';
import 'package:sharpsheel/screens/sixth_screen.dart';
import 'package:sharpsheel/screens/third_screen.dart';
import 'package:sharpsheel/screens/trickiest_quizzes.dart';
import 'package:sharpsheel/screens/types_of_keys.dart';

dynamic routes() => {
  MyHomePage.routeName: (context) => const MyHomePage(title: 'Users List'),
  FirstScreen.routeName: (context) => const FirstScreen(),
  SecondScreen.routeName: (context) => const SecondScreen(),
  ThirdScreen.routeName: (context) => const ThirdScreen(),
  '/fourthScreen': (context) => FourthScreen(),
  '/fifthScreen': (context) => const FifthScreen(),
  '/sixthScreen': (ctx) => const SixthScreen(),
  '/seventh_screen': (_) => const SeventhScreen(),
  FlutterKeysImplementation.routeName: (context) =>
      const FlutterKeysImplementation(),
  FlutterTestingGuide.routeName: (context) => const FlutterTestingGuide(),
  TrickiestQuizzess.routeName: (context) => const TrickiestQuizzess(),
  AnimatedContainerEverySecond.routeName: (context) =>
      const AnimatedContainerEverySecond(),
  ListGenerators.routeName: (context) => const ListGenerators(),
};
