import 'package:flutter/material.dart';
import 'package:sharpsheel/screens/fifth_screen.dart';

class SixthScreen extends StatefulWidget {
  const SixthScreen({super.key});
  static String routeName = '/sixthScreen';
  @override
  State<SixthScreen> createState() => _SixthScreenState();
}

class _SixthScreenState extends State<SixthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sixth Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sixth Screen'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushNamed(context, FifthScreen.routeName);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
