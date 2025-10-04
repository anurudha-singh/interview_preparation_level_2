import 'package:flutter/material.dart';
import 'package:Sharpshell/screens/fifth_screen.dart';

class FourthScreen extends StatelessWidget {
  static const String routeName = '/fourthScreen';
  FourthScreen({super.key});

  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    print('build was called');
    return Scaffold(
      appBar: AppBar(title: Text('Fourth Screen')),
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fourth Screen'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: counter,
              builder: (context, value, child) {
                return Text('Counter: $value');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                counter.value++;
              },
              child: Text('Increment Counter'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, FifthScreen.routeName);
              },
              child: Text('Go to fifth screen'),
            ),
          ],
        ),
      ),
    );
  }
}
