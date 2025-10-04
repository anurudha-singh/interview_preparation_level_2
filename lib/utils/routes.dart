import 'package:Sharpshell/screens/fifth_screen.dart';
import 'package:Sharpshell/screens/first_screen.dart';
import 'package:Sharpshell/screens/fourth_screen.dart';
import 'package:Sharpshell/screens/my_home_page.dart';
import 'package:Sharpshell/screens/second_screen.dart';
import 'package:Sharpshell/screens/seventh_screen.dart';
import 'package:Sharpshell/screens/sixth_screen.dart';
import 'package:Sharpshell/screens/third_screen.dart';
import 'package:Sharpshell/screens/types_of_keys.dart';

dynamic routes() => {
  MyHomePage.routeName: (context) => const MyHomePage(title: 'Users List'),
  FirstScreen.routeName: (context) => const FirstScreen(),
  SecondScreen.routeName: (context) => const SecondScreen(),
  ThirdScreen.routeName: (context) => const ThirdScreen(),
  FourthScreen.routeName: (context) => FourthScreen(),
  FifthScreen.routeName: (context) => const FifthScreen(),
  SixthScreen.routeName: (ctx) => const SixthScreen(),
  SeventhScreen.routeName: (_) => const SeventhScreen(),
  FlutterKeysImplementation.routeName: (context) =>
      const FlutterKeysImplementation(),
};
