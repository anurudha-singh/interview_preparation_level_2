import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharpsheel/screens/fourth_screen.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/users_list.dart';
import 'package:sharpsheel/utils/size_helper.dart';

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
    // Initialize SizeHelper with current context

    return Scaffold(
      appBar: AppBar(title: Text('Platform channel implementation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: SizeHelper.getWidthPercentage(80), // 80% of screen width
              height: SizeHelper.getHeightPercentage(
                10,
              ), // 10% of screen height
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Screen: ${SizeHelper.screenWidth.toInt()} x ${SizeHelper.screenHeight.toInt()}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: SizeHelper.getWidthPercentage(
                    35,
                  ), // 35% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushNamed(context, MyHomePage.routeName);
                    },
                    child: Text('Go Back'),
                  ),
                ),
                SizedBox(
                  width: SizeHelper.getWidthPercentage(
                    35,
                  ), // 35% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      checkBatteryLevelNatively();
                    },
                    child: Text('Check battery %'),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: SizeHelper.getWidthPercentage(70), // 70% of screen width
              height: SizeHelper.getHeightPercentage(6), // 6% of screen height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SecondScreen.routeName);
                },
                child: Text('Go to Second Screen'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: SizeHelper.getWidthPercentage(70), // 70% of screen width
              height: SizeHelper.getHeightPercentage(6), // 6% of screen height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, FourthScreen.routeName);
                },
                child: Text('Go to Fourth Screen'),
              ),
            ),
            // Display screen info
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: SizeHelper.getWidthPercentage(5),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Screen Info:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Width: ${SizeHelper.screenWidth.toStringAsFixed(1)}'),
                  Text('Height: ${SizeHelper.screenHeight.toStringAsFixed(1)}'),
                  Text(
                    'Orientation: ${SizeHelper.isPortrait ? "Portrait" : "Landscape"}',
                  ),
                  Text(
                    'Status Bar Height: ${SizeHelper.statusBarHeight.toStringAsFixed(1)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
