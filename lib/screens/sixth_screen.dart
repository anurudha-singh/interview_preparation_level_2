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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Sixth Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Navigate back to see that the scroll position\nis maintained in the Fifth Screen list!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back to Fifth Screen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, FifthScreen.routeName);
                  },
                  child: Text('Push Fifth Screen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
