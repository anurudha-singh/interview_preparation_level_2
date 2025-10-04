import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharpsheel/utils/routes.dart';
import 'package:sharpsheel/utils/size_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global PageStorageBucket for the entire app
  static final PageStorageBucket _bucket = PageStorageBucket();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeHelper.init(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Wrap the entire app with PageStorage
      builder: (context, child) {
        return PageStorage(bucket: _bucket, child: child!);
      },
      routes: routes(),
    );
  }
}
