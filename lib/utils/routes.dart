import 'package:sharpsheel/screens/first_screen.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/third_screen.dart';
import 'package:sharpsheel/screens/users_list.dart';

dynamic routes() => {
  MyHomePage.routeName: (context) => const MyHomePage(title: 'Users List'),
  FirstScreen.routeName: (context) => FirstScreen(),
  SecondScreen.routeName: (context) => SecondScreen(),
  ThirdScreen.routeName: (context) => ThirdScreen(),
};
