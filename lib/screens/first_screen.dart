import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharpsheel/screens/users_list.dart';

class FirstScreen extends StatefulWidget {
  static String routeName = '/firstScreen';
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  MethodChannel platformChannel = MethodChannel('com.example.battery');

  void checkBatteryLevelNatively() async {
    int batteryLevel = await platformChannel.invokeMethod('getBatteryLevel');
    print('Battery level: $batteryLevel %');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Battery level: $batteryLevel %')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Platform channel implementation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('First Screen'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, MyHomePage.routeName);
                  },
                  child: Text('Go Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkBatteryLevelNatively();
                  },
                  child: Text('Check battery %'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
