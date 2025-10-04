import 'package:Sharpshell/screens/fifth_screen.dart';
import 'package:Sharpshell/screens/first_screen.dart';
import 'package:Sharpshell/screens/fourth_screen.dart';
import 'package:Sharpshell/screens/second_screen.dart';
import 'package:Sharpshell/screens/seventh_screen.dart';
import 'package:Sharpshell/screens/sixth_screen.dart';
import 'package:Sharpshell/screens/third_screen.dart';
import 'package:Sharpshell/screens/my_home_page.dart';

dynamic routes() => {
  MyHomePage.routeName: (context) => const MyHomePage(title: 'Users List'),
  FirstScreen.routeName: (context) => FirstScreen(),
  SecondScreen.routeName: (context) => SecondScreen(),
  ThirdScreen.routeName: (context) => ThirdScreen(),
  FourthScreen.routeName: (context) => FourthScreen(),
  FifthScreen.routeName: (context) => FifthScreen(),
  SixthScreen.routeName: (ctx) => SixthScreen(),
  SeventhScreen.routeName: (_) => SeventhScreen(),
};
