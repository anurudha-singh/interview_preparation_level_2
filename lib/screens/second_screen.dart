import 'package:flutter/material.dart';
import 'package:sharpsheel/screens/first_screen.dart';
import 'package:sharpsheel/screens/third_screen.dart';
import 'package:sharpsheel/utils/resuable_widget.dart';
import 'package:sharpsheel/utils/size_helper.dart';

class SecondScreen extends StatefulWidget {
  static String routeName = '/secondScreen';
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the argument passed from the first screen
    String receivedArgumentFromScreenOne =
        ModalRoute.of(context)?.settings.arguments as String;

    // Initialize SizeHelper with current context
    SizeHelper.init(context);

    return Scaffold(
      appBar: AppBar(title: Text('Second Screen')),
      body: LayoutBuilder(
        //It gives you the actual size constraints of the parent so you can adapt your UI dynamically.
        builder: (context, constraints) {
          if (SizeHelper.screenWidth > 600) {
            return buildWideContainers();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeHelper.getWidthPercentage(90),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to the Second Screen!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Date Received from screen 1 using Routes:: ${receivedArgumentFromScreenOne}',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Screen: ${SizeHelper.screenWidth.toInt()} x ${SizeHelper.screenHeight.toInt()}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          'Orientation: ${SizeHelper.isPortrait ? "Portrait" : "Landscape"}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeHelper.getWidthPercentage(80),
                    height: SizeHelper.getHeightPercentage(6),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, FirstScreen.routeName);
                      },
                      child: Text('Go Back to First Screen'),
                    ),
                  ),
                  SizedBox(
                    width: SizeHelper.getWidthPercentage(80),
                    height: SizeHelper.getHeightPercentage(6),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ThirdScreen.routeName);
                      },
                      child: Text('Go to Third Screen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
