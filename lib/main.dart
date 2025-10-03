import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharpsheel/model/users_model.dart';
import 'package:sharpsheel/screens/first_screen.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/users_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        MyHomePage.routeName: (context) =>
            const MyHomePage(title: 'Users List'),
        FirstScreen.routeName: (context) => FirstScreen(),
        SecondScreen.routeName: (context) => SecondScreen(),
      },
    );
  }
}
