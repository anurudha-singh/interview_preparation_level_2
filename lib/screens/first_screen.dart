import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharpsheel/screens/fourth_screen.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/third_screen.dart';
import 'package:sharpsheel/screens/users_list.dart';
import 'package:sharpsheel/utils/resuable_widget.dart';
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
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
          ),
          child: Column(
            children: [
              // Enhanced DrawerHeader with user profile
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Avatar
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    SizedBox(height: 12),
                    // User Name
                    Text(
                      'Anurudha Singh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    // User Email
                    Text(
                      'anurudha@sharpshell.ai',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Navigation Items
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      buildDrawerItem(
                        icon: Icons.home_outlined,
                        title: 'First Screen',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, FirstScreen.routeName);
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Third Screen',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ThirdScreen.routeName);
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.analytics_outlined,
                        title: 'Fourth Screen',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/fourthScreen');
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.list_alt_outlined,
                        title: 'Fifth Screen (ValueNotifier)',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/fifthScreen');
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.web_outlined,
                        title: 'Sixth Screen',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/sixthScreen');
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.assignment_outlined,
                        title: 'Seventh Screen (Form)',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/seventh_screen');
                        },
                      ),

                      // Divider
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Divider(color: Colors.grey.shade300),
                      ),

                      // Settings Section
                      buildDrawerItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Settings coming soon!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Help section coming soon!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      buildDrawerItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {
                          Navigator.pop(context);
                          showAboutDialog(context: context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.flutter_dash, color: Colors.blue.shade600),
                    SizedBox(width: 8),
                    Text(
                      'SharpSheel App v1.0.0',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

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
                  Navigator.pushNamed(
                    context,
                    SecondScreen.routeName,
                    arguments:
                        'This is the argument which is being passed from first screen to second screen ',
                  );
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
