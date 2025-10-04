import 'package:flutter/material.dart';
import 'package:sharpsheel/screens/first_screen.dart';
import 'package:sharpsheel/screens/second_screen.dart';
import 'package:sharpsheel/screens/third_screen.dart';
import 'package:sharpsheel/screens/types_of_keys.dart';
import 'package:sharpsheel/screens/flutter_testing_guide.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                          offset: Offset(0, 4),
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
                    _buildDrawerItem(
                      context,
                      icon: Icons.battery_charging_full_outlined,
                      title: 'First Screen (Platform Channel)',
                      route: FirstScreen.routeName,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.devices_outlined,
                      title: 'Second Screen (Responsive)',
                      route: SecondScreen.routeName,
                      arguments: 'Navigated from persistent drawer',
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.dashboard_outlined,
                      title: 'Third Screen isolate demo',
                      route: ThirdScreen.routeName,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.analytics_outlined,
                      title: 'Fourth Screen',
                      route: '/fourthScreen',
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.list_alt_outlined,
                      title: 'Fifth Screen (ValueNotifier)',
                      route: '/fifthScreen',
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.web_outlined,
                      title: 'Sixth Screen',
                      route: '/sixthScreen',
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.assignment_outlined,
                      title: 'Seventh Screen (Form)',
                      route: '/seventh_screen',
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.key_outlined,
                      title: 'Flutter Keys Implementation',
                      route: FlutterKeysImplementation.routeName,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.quiz_outlined,
                      title: 'Flutter Testing Guide',
                      route: FlutterTestingGuide.routeName,
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
                    _buildDrawerItem(
                      context,
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
                    _buildDrawerItem(
                      context,
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
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
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
                    'Sharpshell App v1.0.0',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build drawer items with consistent styling
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    Object? arguments,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap:
            onTap ??
            () {
              Navigator.pop(context);
              if (route != null) {
                Navigator.pushNamed(context, route, arguments: arguments);
              }
            },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: Colors.blue.shade50,
        splashColor: Colors.blue.shade100,
      ),
    );
  }

  // Helper method to show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue.shade600),
              SizedBox(width: 8),
              Text('About Sharpshell'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🚀 Sharpshell Demo App'),
              SizedBox(height: 8),
              Text('Version: 1.0.0'),
              SizedBox(height: 8),
              Text('Built with Flutter & ❤️'),
              SizedBox(height: 8),
              Text('© 2025 Sharpshell.AI'),
              SizedBox(height: 12),
              Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('• Platform Channels'),
              Text('• Responsive Design'),
              Text('• ValueNotifier State Management'),
              Text('• Form Validation'),
              Text('• Page Storage'),
              Text('• Beautiful UI Components'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.blue.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}
